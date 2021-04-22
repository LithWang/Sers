using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Hosting.Server;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Features;
using Vit.Core.Module.Log;
using Vit.Extensions;
using Vit.Extensions.ObjectExt;

namespace Sers.Serslot
{
    public class SerslotServer : IServer
    {
        /// <summary>
        /// 
        /// </summary>
        public IServiceProvider serviceProvider { get; set; }

        #region PairingToken       
        string pairingToken;
        public void InitPairingToken(IWebHostBuilder hostBuilder)
        {
            //search "MS-ASPNETCORE-TOKEN" to know why
            string PairingToken = "TOKEN";
            pairingToken = hostBuilder.GetSetting(PairingToken) ?? Environment.GetEnvironmentVariable($"ASPNETCORE_{PairingToken}");

        }
        #endregion



        #region ProcessRequest       

        Action<FeatureCollection> OnProcessRequest;

        public IHttpResponseFeature ProcessRequest(HttpRequestFeature requestFeature)
        {
            if (requestFeature.Headers == null)
                requestFeature.Headers = new HeaderDictionary();

            //var header = "{\"Cache-Control\":\"max-age=0\",\"Connection\":\"Keep-Alive\",\"Accept\":\"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\",\"Accept-Encoding\":\"gzip, deflate\",\"Accept-Language\":\"zh-CN,zh;q=0.8\",\"Host\":\"localhost:44308\",\"User-Agent\":\"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 SE 2.X MetaSr 1.0\",\"Upgrade-Insecure-Requests\":\"1\",\"X-Forwarded-For\":\"127.0.0.1:53093\",\"X-Forwarded-Proto\":\"https\"}";
            //header = "{\"Host\":\"localhost:44308\",\"X-Forwarded-For\":\"127.0.0.1:53093\",\"X-Forwarded-Proto\":\"https\"}";


            //ʹ��Add���ܱ��� An item with the same key has already been added. Key: X-Forwarded-Proto"
            //requestFeature.Headers.Add("MS-ASPNETCORE-TOKEN", pairingToken);
            //requestFeature.Headers.Add("X-Forwarded-Proto", "https");

            requestFeature.Headers["MS-ASPNETCORE-TOKEN"] = pairingToken;
            requestFeature.Headers["X-Forwarded-Proto"] = "https";

            var features = new FeatureCollection();
            features.Set<IHttpRequestFeature>(requestFeature);

            //var _responseFeature = new SerslotResponseFeature() { Body = new MemoryStream() };
            var _responseFeature = new HttpResponseFeature() { Body = new MemoryStream() };
            features.Set<IHttpResponseFeature>(_responseFeature);


            //IHttpResponseBodyFeature
            if (Type_IResponseBodyFeature != null)
            {
                features[Type_IResponseBodyFeature] = Activator.CreateInstance(Type_ResponseBodyFeature, _responseFeature.Body);
            }


            OnProcessRequest(features);

            return _responseFeature;
        }

        #region SerslotResponseFeature
        class SerslotResponseFeature : IHttpResponseFeature
        {
            public SerslotResponseFeature()
            {
                StatusCode = 200;
                Headers = new HeaderDictionary();
                Body = Stream.Null;
            }


            public int StatusCode
            {
                get;
                set;
            }

            public string ReasonPhrase
            {
                get;
                set;
            }

            public IHeaderDictionary Headers
            {
                get;
                set;
            }

            public Stream Body
            {
                get;
                set;
            }

            public virtual bool HasStarted { get; set; } = false;




            private Stack<KeyValuePair<Func<object, Task>, object>> _onStarting;
            private Stack<KeyValuePair<Func<object, Task>, object>> _onCompleted;


            #region OnStarting
            public virtual void OnStarting(Func<object, Task> callback, object state)
            {
                lock (this)
                {
                    if (HasStarted)
                    {
                        throw new InvalidOperationException(nameof(OnStarting));
                    }

                    if (_onStarting == null)
                    {
                        _onStarting = new Stack<KeyValuePair<Func<object, Task>, object>>();
                    }
                    _onStarting.Push(new KeyValuePair<Func<object, Task>, object>(callback, state));
                }
            }

            public Task FireOnStarting()
            {
                Stack<KeyValuePair<Func<object, Task>, object>> onStarting;
                lock (this)
                {
                    onStarting = _onStarting;
                    _onStarting = null;
                }

                if (onStarting == null)
                {
                    return Task.CompletedTask;
                }
                else
                {
                    return FireOnStartingMayAwait(onStarting);
                }

            }

            private Task FireOnStartingMayAwait(Stack<KeyValuePair<Func<object, Task>, object>> onStarting)
            {
                try
                {
                    var count = onStarting.Count;
                    for (var i = 0; i < count; i++)
                    {
                        var entry = onStarting.Pop();
                        var task = entry.Key.Invoke(entry.Value);
                        if (!ReferenceEquals(task, Task.CompletedTask))
                        {
                            return FireOnStartingAwaited(task, onStarting);
                        }
                    }
                }
                catch (Exception ex)
                {
                    Logger.Error(ex);
                }

                return Task.CompletedTask;
            }

            private async Task FireOnStartingAwaited(Task currentTask, Stack<KeyValuePair<Func<object, Task>, object>> onStarting)
            {
                try
                {
                    await currentTask;

                    var count = onStarting.Count;
                    for (var i = 0; i < count; i++)
                    {
                        var entry = onStarting.Pop();
                        await entry.Key.Invoke(entry.Value);
                    }
                }
                catch (Exception ex)
                {
                    Logger.Error(ex);
                }
            }
            #endregion


            #region OnCompleted           
            public virtual void OnCompleted(Func<object, Task> callback, object state)
            {
                lock (this)
                {
                    if (onCompleted == null)
                    {
                        onCompleted = new Stack<KeyValuePair<Func<object, Task>, object>>();
                    }
                    onCompleted.Push(new KeyValuePair<Func<object, Task>, object>(callback, state));
                }
            }
            Stack<KeyValuePair<Func<object, Task>, object>> onCompleted = null;
            public Task FireOnCompleted()
            {
                Stack<KeyValuePair<Func<object, Task>, object>> onCompleted;
                lock (this)
                {
                    onCompleted = _onCompleted;
                    _onCompleted = null;
                }

                if (onCompleted == null)
                {
                    return Task.CompletedTask;
                }

                return FireOnCompletedAwaited(onCompleted);
            }

            private async Task FireOnCompletedAwaited(Stack<KeyValuePair<Func<object, Task>, object>> onCompleted)
            {
                foreach (var entry in onCompleted)
                {
                    try
                    {
                        await entry.Key.Invoke(entry.Value);
                    }
                    catch (Exception ex)
                    {
                        Logger.Error(ex);
                    }
                }
            }
            #endregion
        }

        #endregion

        #endregion


        Type Type_IResponseBodyFeature = Vit.Core.Util.Reflection.ObjectLoader.GetType("Microsoft.AspNetCore.Http.Features.IHttpResponseBodyFeature", assemblyName: "Microsoft.AspNetCore.Http.Features");

        Type Type_ResponseBodyFeature = Vit.Core.Util.Reflection.ObjectLoader.GetType("Microsoft.AspNetCore.Http.StreamResponseBodyFeature", assemblyName: "Microsoft.AspNetCore.Http");


        public IFeatureCollection Features { get; } = new FeatureCollection();


        public async Task StartAsync<TContext>(IHttpApplication<TContext> application, CancellationToken cancellationToken)
        {
            try
            {
                #region (x.1) build OnProcessRequest               
                OnProcessRequest = (features) =>
                {

                    Exception _applicationException = null;

                    var httpContext = application.CreateContext(features);
                    try
                    {

                        //var httpContext_ = httpContext.GetProperty<object>("HttpContext");
                        //if (httpContext_ is Microsoft.AspNetCore.Http.HttpContext defaultHttpContext)
                        //{
                        //    //if (defaultHttpContext.Response.Body == null)                            
                        //    defaultHttpContext.Response.Body = features.Get<IHttpResponseFeature>().Body;                           
                        //}




                        // Run the application code for this request
                        // application.ProcessRequestAsync(httpContext).GetAwaiter().GetResult();
                        application.ProcessRequestAsync(httpContext).Wait();


                        //var _responseFeature = features.Get<IHttpResponseFeature>() as SerslotResponseFeature;
                        //if (_responseFeature != null)
                        //{                           
                        //    _responseFeature.FireOnStarting();
                        //    _responseFeature.FireOnCompleted();
                        //}
                    }
                    catch (Exception ex)
                    {
                        _applicationException = ex;
                        Logger.Error(ex);
                    }
                    application.DisposeContext(httpContext, _applicationException);
                };
                #endregion


                #region (x.2) start ServiceStation                

                #region (x.x.1) Init
                ServiceStation.ServiceStation.Init();
                Sers.Core.Module.App.SersApplication.onStop += () =>
                {
                    if (serviceProvider.GetService(typeof(IApplicationLifetime)) is IApplicationLifetime lifetime)
                    {
                        lifetime.StopApplication();
                    }
                };
                #endregion


                #region (x.x.2)����api           

                ServiceStation.ServiceStation.Instance.LoadApi();

                ServiceStation.ServiceStation.Instance.localApiService.LoadSerslotApi(Assembly.GetEntryAssembly(), this);


                #endregion

                //(x.x.3)Start ServiceStation
                if (!ServiceStation.ServiceStation.Start())
                {
                    Dispose();
                }
                #endregion

            }
            catch (Exception ex)
            {
                Dispose();
                throw;
            }
        }

        // Graceful shutdown if possible
        public async Task StopAsync(CancellationToken cancellationToken)
        {

            try
            {
                ServiceStation.ServiceStation.Stop();
            }
            catch (Exception ex)
            {
                Logger.Error(ex);
            }
        }

        // Ungraceful shutdown
        public void Dispose()
        {
            var cancelledTokenSource = new CancellationTokenSource();
            cancelledTokenSource.Cancel();
            StopAsync(cancelledTokenSource.Token).GetAwaiter().GetResult();
        }

    }
}