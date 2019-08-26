#pragma once

#include <string>
#include <string.h>
#include <unordered_map>
#include <unordered_set>
#include <functional>
#include "mongoose.h"

#include <utility>
#include "../../../Data/ByteData.hpp"
#include "../../../Module/json/Json.hpp"
#include "../../../Module/Api/ApiClient.hpp"
#include "../../../Module/Log/Logger.hpp"

#include "../../../../Core/Module/App/SersApplication.hpp"
#include "../../../../Core/Util/Threading/LongTaskHelp.h"

namespace Sers {

using namespace std;




 
typedef void FuncOnHttpRequest(HttpApiContext & httpContext);

using HttpRequestHandler = std::function<FuncOnHttpRequest>;



struct HttpContext{
	struct mg_connection *connection;
	HttpApiContext* apiContext;
};




class HttpServer
{
private:

	static mg_mgr m_mgr;          // 连接管理器

	 static sock_t sock[2];

	 static bool isRunning;

	 static LongTaskHelp taskToPoll;

public:

	// 端口
	static std::string m_port;
	static  int workThreadCount;
	static string responseDefaultContentType;
	static string responseExtHeaders;
	static HttpRequestHandler OnHttpRequest;


	// 启动httpserver multi Thread
	static bool Start(){
		if(isRunning) return true;


		Logger::Info("[HttpServer]try start...");

		  //(x.1)init mg_socketpair
		if (mg_socketpair(sock, SOCK_STREAM) == 0) {
			Logger::Info("[HttpServer]start fail. can't open socket pair");
			Logger::Error("[HttpServer]start fail. can't open socket pair");
			return false;
		  }


		  signal(SIGTERM, signal_handler);
		  signal(SIGINT, signal_handler);


		//(x.2) init mgr
		mg_mgr_init(&m_mgr, NULL);

		mg_connection *connection = mg_bind(&m_mgr, m_port.c_str(), ev_handler);
		if (connection == NULL){
			Logger::Info("[HttpServer]start fail.call mg_bind failed");
			Logger::Error("[HttpServer]start fail.call mg_bind failed");
			return false;
		}
		// for both http and websocket
		mg_set_protocol_http_websocket(connection);


		//(x.3) start back thread
		for (int i = 0; i < workThreadCount; i++) {
		    mg_start_thread(worker_thread_proc, &m_mgr);
		}

		Logger::Info(string("[HttpServer]start success. port:")+m_port);
		isRunning=true;

		//(x.4) regist close action
		SersApplication::AddActionOnstop(Close);

		//(x.5) start thread for main loop
		auto mainLoop=  [](void* lp){
			mg_mgr * mgr=(mg_mgr *)lp;

			//http main loop
			while (SersApplication::isRunning)
				mg_mgr_poll(mgr, 200); // ms

		} ;
		taskToPoll.Action_Set(mainLoop,&m_mgr);
		taskToPoll.Start();

		return true;
	}




	// 关闭
	static void Close(){
		if(isRunning){
			 taskToPoll.Stop_Temp();

			  mg_mgr_free(&m_mgr);

			  closesocket(sock[0]);
			  closesocket(sock[1]);
			  isRunning=false;
		}
	}

private:

	//str demo "\nheader1:123\nheader2:88"
	static  void HandleHttpEvent_HeaderForeach(Json& item,void* lp){
		string* str=(string*)lp;

		str->append("\r\n");
		str->append(item.GetName());
		str->append(":");
		str->append(item.ToString());
	}


	static void BuildApiRequest(http_message *http_req,HttpApiContext& context)
	{
		
		//(x.1) init request
		//(x.x.1) route url method
		context.route = string(http_req->uri.p, http_req->uri.len);
		string query_string = string(http_req->query_string.p, http_req->query_string.len);
		context.rpc_method = string(http_req->method.p, http_req->method.len);
		//string body = string(http_req->body.p, http_req->body.len);
		if(query_string.empty()){
			context.rpc_url=context.route;
		}else{
			context.rpc_url=context.route+"?"+query_string;
		}
		//(x.x.2) request_body
		if(http_req->body.len>0){
			context.request_body.CopyFrom(http_req->body.p, http_req->body.len);
		}else if(!query_string.empty()){
			Json query;
			query.CreateObject();
			ParseQueryString(http_req->query_string.p,http_req->query_string.len,query);
			string queryValue=query.ToString();
			context.request_body.CopyFrom(queryValue.c_str(),queryValue.length());
		}



		//(x.x.2) init request header
		context.request_header.CreateObject();
		string header_name,header_value;
		for(int t=0;t<MG_MAX_HTTP_HEADERS;t++){
			mg_str & name=http_req->header_names[t];
			if(name.len<=0) break;
			header_name.assign(name.p,name.len);

			mg_str & value=http_req->header_values[t];
			header_value.assign(value.p,value.len);

			context.request_header.SetValue(header_name,header_value);
		}

	}


	// buf:  a=1&b=2&c=3
	static void ParseQueryString(const char * buf,int len, Json& json) {

		const char * cur=buf;
		const char * end=buf+len;

		const char * tmp;
		char name[256],value[1000];
		while(cur<end){

			//(x.1) get name
			tmp = (char *) memchr(cur, '=', (size_t)(end - cur));
			if(!tmp) break;
			mg_url_decode(cur,tmp-cur,name,256,1);
			cur=tmp+1;

			//(x.2) get value
			tmp = (const char *) memchr(cur, '&', (size_t)(end - cur));
			if(!tmp) {
				tmp=end;
			}
			mg_url_decode(cur,tmp-cur,value,1000,1);
			cur=tmp+1;
			json.SetValue(name,value);
		}
	}



	static void signal_handler(int sig_num) {
		signal(sig_num, signal_handler);

		if(sig_num!=0)
			SersApplication::Stop();
	}

	static void on_work_complete(struct mg_connection *nc, int ev, void *ev_data) {


			HttpContext*  httpContext=(HttpContext* )ev_data;

			mg_connection * connection = httpContext->connection;

			if(connection!=nc) return;


			HttpApiContext & context=(* httpContext->apiContext);

			//(x.3) send reply
			//(x.3.1)send header
			//reply_header demo "\nheader1:123\nheader2:88"
			string reply_header("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked");

			if(responseExtHeaders.length()>0){
				reply_header.append(responseExtHeaders);
			}

			if(context.response_header.IsEmpty()){
				reply_header.append("\nContent-Type:"+responseDefaultContentType);
			}else{
				if(context.response_header.GetValueString("Content-Type").length()==0){
					reply_header.append("\nContent-Type:"+responseDefaultContentType);
				}
				context.response_header.Foreach(HandleHttpEvent_HeaderForeach,(void*) &reply_header);
			}

			reply_header.append("\r\n\r\n");
			mg_printf(connection, reply_header.c_str());

			// (x.3.2)send body
			mg_send_http_chunk(connection, context.response_body.GetData(),context.response_body.len);

			// 发送空白字符快，结束当前响应
			mg_send_http_chunk(connection, "", 0);
			connection->flags |= MG_F_SEND_AND_CLOSE;

	}

	static void *worker_thread_proc(void *param) {
	  struct mg_mgr *mgr = (struct mg_mgr *) param;
	  HttpContext  httpContext;

	  while (SersApplication::isRunning) {

		  	//(x.1) read request from sock
			if (read(sock[1], &httpContext, sizeof(HttpContext)) < 0){
				Sers::Logger::Error("[HttpServer_mongoose]Reading worker sock error");
				continue;
			}

			//(x.2) callback
			OnHttpRequest((*httpContext.apiContext));


			mg_broadcast(mgr, on_work_complete, (void *)&httpContext, sizeof(HttpContext));
	  }
	  return NULL;
	}

	static void ev_handler(struct mg_connection *nc, int ev, void *ev_data) {

		  HttpContext * httpContext;
		  switch (ev) {
			  case MG_EV_ACCEPT:
			  {
					httpContext=new HttpContext;
					httpContext->connection=nc;
					httpContext->apiContext=new HttpApiContext;

					nc->user_data = httpContext;

					break;
			  }
			  case MG_EV_HTTP_REQUEST: {
				  if(!nc->user_data) break;
				  httpContext=(HttpContext*)nc->user_data;


				  BuildApiRequest( (http_message *)ev_data,(*httpContext->apiContext));

				  if (write(sock[0],httpContext, sizeof(HttpContext)) < 0){
					  Sers::Logger::Error("[HttpServer_mongoose]Writing worker sock error");
				  }
				  break;
			  }
			  case MG_EV_CLOSE: {
				if (nc->user_data){
					httpContext=(HttpContext*)nc->user_data;
					delete httpContext->apiContext;
					delete httpContext;
					nc->user_data = NULL;
				}
			  }
			}



	}
};





} /* namespace Sers */
