## (1)MessageFrame(Mq)
>ֻ������Ϣ֡���ݣ���������������

### (x.1)IMqConn

#### (x.x.1)state
	����״̬(0:waitForCertify; 2:certified; 4:waitForClose; 8:closed;)
#### (x.x.2)connTag
#### (x.x.3)SendFrameAsync
#### (x.x.4)Close


### (x.2)ServerMq:

Start
Stop
ConnectedList
Conn_OnConnected
Conn_OnDisconnected
Conn_OnGetFrame 


### (x.3)ClientMq:
 
Connect
Close
mqConn
Conn_OnDisconnected 
OnGetFrame
secretKey



## (2)MqManager

### (x.1)ServerMqManager

Start
Stop

Conn_OnConnected
Conn_OnDisconnected

station_OnGetRequest
station_OnGetMessage

Station_SendRequestAsync
Station_SendMessageAsync



### (x.2)ClientMqManager

Start
Stop

mqConns 
Conn_OnDisconnected

station_OnGetRequest
station_OnGetMessage
  
Station_SendRequest
Station_SendMessageAsync


### (x.3)RequestAdaptor
 ������������棬ת������������� 



## (3)Service

### (x.1)ServerCenter

#### (x.x.1)actionsOnStart actionsOnStop
#### (x.x.2)mqMng
		�߳�����Sers.Mq.Config.workThreadCount
#### (x.x.3)localApiService
		�߳�����Sers.LocalApiService.workThreadCount
#### (x.x.4)ApiClient
#### (x.x.5)MessageClient
#### (x.x.6)ApiCenterService
		�߳�����0��������mqMng�߳������
#### (x.x.7)MessageCenterService



### (x.2)ServerStation

#### (x.x.1)actionsOnStart actionsOnStop
#### (x.x.2)mqMng
		�߳�����Sers.Mq.Config.workThreadCount
#### (x.x.3)localApiService
		�߳�����Sers.LocalApiService.workThreadCount
#### (x.x.4)ApiClient
#### (x.x.5)MessageClient

 











