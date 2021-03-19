﻿using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Threading;
using Newtonsoft.Json.Linq;
using Sers.Core.CL.MessageDelivery;
using Sers.Core.Util.Consumer;
using Vit.Core.Module.Log;
using Vit.Core.Util.Common;
using Vit.Core.Util.Pipelines;
using Vit.Core.Util.Pool;
using Vit.Core.Util.Threading;
using Vit.Extensions;

namespace Sers.Core.CL.MessageOrganize.DefaultOrganize
{
    /// <summary>
    /// 协调 MessageDelivery  和 MessageOrganize，只负责处理数据，不负责管理打开或关闭事件
    /// </summary>
    public class RequestAdaptor
    {


        //                     Delivery                                                                                                      Organize        
        //
        //  ->   DeliveryToOrganize_OnGetMessageFrame    ->    DeliveryToOrganize_MessageFrameQueue    ->    DeliveryToOrganize_Processor       ->         Event_OnGetRequest Event_OnGetMessage 
        //
        //  <-        Delivery_SendFrameAsync            <-                 organizeToDelivery_RequestMap                                       <-         SendRequestAsync SendRequest SendMessageAsync   
        //
        //


        // HeartBeat


        #region (x.1)对外接口


        #region (x.x.1)event

        /// <summary>
        /// deliveryToOrganize_OnGetRequest
        /// 会在内部线程中被调用 
        /// (conn,sender,requestData,callback)
        /// </summary>
        public Action<IOrganizeConnection, object, ArraySegment<byte>, Action<object, Vit.Core.Util.Pipelines.ByteData>> event_OnGetRequest { private get; set; }

        /// <summary>
        /// deliveryToOrganize_OnGetMessage
        /// 会在内部线程中被调用
        /// </summary>
        public Action<IOrganizeConnection, ArraySegment<byte>> event_OnGetMessage { private get; set; }


        public Func<IEnumerable<IOrganizeConnection>> GetConnList { private get; set; }

        #endregion


        #region (x.x.2)SendMessage SendRequest


        public void SendMessageAsync(IOrganizeConnection conn, Vit.Core.Util.Pipelines.ByteData message)
        {
            Delivery_SendFrameAsync(conn, (byte)EFrameType.message, 0, message);
        }



        public long SendRequestAsync(IOrganizeConnection conn, Object sender, Vit.Core.Util.Pipelines.ByteData requestData, Action<object, Vit.Core.Util.Pipelines.ByteData> callback, ERequestType requestType = ERequestType.app)
        {
            //no need guid,just make sure reqKey is unique in current connection client
            //long reqKey = CommonHelp.NewGuidLong();
            long reqKey = Interlocked.Increment(ref reqKeyIndex);

            var requestInfo = new OrganizeToDelivery_RequestInfo();
            requestInfo.sender = sender;
            requestInfo.callback = callback;

            OrganizeToDelivery_RequestMap_Set(ref reqKey, requestInfo);

            PackageReqRepFrame(reqKey, requestData, out var reqRepFrame);

            //SendRequest
            Delivery_SendFrameAsync(conn, (byte)EFrameType.request, (byte)requestType, reqRepFrame);
            return reqKey;
        }

        #region static curAutoResetEvent      
        public static AutoResetEvent curAutoResetEvent   => 
            _curAutoResetEvent.Value ?? (_curAutoResetEvent.Value = new AutoResetEvent(false));  

        static ThreadCache<AutoResetEvent> _curAutoResetEvent = new ThreadCache<AutoResetEvent>();
        #endregion


        public bool SendRequest(IOrganizeConnection conn, Vit.Core.Util.Pipelines.ByteData requestData, out ByteData replyData)
        {
            ByteData _replyData = null;

            AutoResetEvent mEvent = curAutoResetEvent;    
            mEvent.Reset();

            long reqKey = SendRequestAsync(conn, null, requestData, (sender, replyData_) => {
                _replyData = replyData_;
                mEvent?.Set();
            });

            bool success;
            try
            {
                success = mEvent.WaitOne(requestTimeoutMs);
            }
            finally
            {
                mEvent = null;
            }


            if (success)
            {        
                replyData = _replyData;
                return true;
            }
            else
            {
                if (OrganizeToDelivery_RequestMap_TryRemove(reqKey, out var requestInfo))
                {
                   
                }
                replyData = null;
                return false;
            }

        }

        #endregion



        #region (x.x.3)Start Stop BindConnection


        public void Start()
        {
            //(x.1) task_DeliveryToOrganize_Processor
            //task_DeliveryToOrganize_Processor.Stop();
            task_DeliveryToOrganize_Processor.processor = DeliveryToOrganize_ProcessFrame;
            task_DeliveryToOrganize_Processor.workThreadCount = workThreadCount;
            task_DeliveryToOrganize_Processor.name = "CL-RequestAdaptor-dealer";
            task_DeliveryToOrganize_Processor.Start(); 

            //(x.2) heartBeat thread
            heartBeat_Timer.timerCallback = (state) => { HeartBeat_Loop(); };
            heartBeat_Timer.intervalMs = heartBeatIntervalMs;

            if (heartBeatIntervalMs > 0)
                heartBeat_Timer.Start();

        }

        public void Stop()
        {
            task_DeliveryToOrganize_Processor.Stop();

            heartBeat_Timer.Stop();
        }


        public void BindConnection(IDeliveryConnection deliveryConn, IOrganizeConnection organizeConn)
        {
            deliveryConn.OnGetFrame = (_, data) => { DeliveryToOrganize_OnGetMessageFrame(organizeConn, data); };
        }





        #endregion


        #region (x.x.4)构造函数       
        public RequestAdaptor(JObject config)
        {
            requestTimeoutMs = config["requestTimeoutMs"]?.Deserialize<int?>() ?? requestTimeoutMs;

            workThreadCount = config["workThreadCount"]?.Deserialize<int?>() ?? workThreadCount;
            heartBeatTimeoutMs = config["heartBeatTimeoutMs"]?.Deserialize<int?>() ?? heartBeatTimeoutMs;
            heartBeatRetryCount = config["heartBeatRetryCount"]?.Deserialize<int?>() ?? heartBeatRetryCount;
            heartBeatIntervalMs = config["heartBeatIntervalMs"]?.Deserialize<int?>() ?? heartBeatIntervalMs;
            requestTimeoutMs = config["requestTimeoutMs"]?.Deserialize<int?>() ?? requestTimeoutMs;
        }
        #endregion


        #endregion
               



        #region (x.2)成员对象

        #region (x.x.1)

  
        long reqKeyIndex = CommonHelp.NewGuidLong();
   
        #endregion


        #region (x.x.2)config

        /// <summary>
        /// 后台处理消息的线程个数（单位个，默认2）
        /// </summary>
        int workThreadCount = 2;

        /// <summary>
        /// 请求超时时间（单位ms，默认60000）
        /// </summary>
        public int requestTimeoutMs = 60000;

        /// <summary>
        /// 心跳检测超时时间（单位ms，默认30000）
        /// </summary>
        int heartBeatTimeoutMs = 30000;
        /// <summary>
        /// 心跳检测失败重试次数（单位次，默认10）
        /// </summary>
        int heartBeatRetryCount = 10;
        /// <summary>
        /// 心跳检测时间间隔（单位ms，默认10000,若指定为0则不进行心跳检测）
        /// </summary>
        int heartBeatIntervalMs = 10000;


        #endregion


        #endregion



        #region (x.3)DeliveryToOrganize       



        #region deliveryToOrganize_MessageFrameQueue  


        IConsumer<DeliveryToOrganize_MessageFrame> task_DeliveryToOrganize_Processor = new Consumer_BlockingCollection<DeliveryToOrganize_MessageFrame>();
        //IConsumer<DeliveryToOrganize_MessageFrame> task_DeliveryToOrganize_Processor = new Consumer_Disruptor<DeliveryToOrganize_MessageFrame>();
        //IConsumer<DeliveryToOrganize_MessageFrame> task_DeliveryToOrganize_Processor = new Consumer_WorkerPool<DeliveryToOrganize_MessageFrame>();
        //IConsumer<DeliveryToOrganize_MessageFrame> task_DeliveryToOrganize_Processor = new Consumer_WorkerPoolCache<DeliveryToOrganize_MessageFrame>();
        //IConsumer<DeliveryToOrganize_MessageFrame> task_DeliveryToOrganize_Processor = new Consumer_WorkerPoolCascade<DeliveryToOrganize_MessageFrame>();


        void DeliveryToOrganize_OnGetMessageFrame(IOrganizeConnection conn, ArraySegment<byte> messageFrame)
        {
            var msg = DeliveryToOrganize_MessageFrame.Pop();
            msg.conn = conn;
            msg.messageFrame = messageFrame;

            task_DeliveryToOrganize_Processor.Publish(msg);    
        }


        #region class DeliveryToOrganize_MessageFrame  DeliveryToOrganize_RequestInfo
        class DeliveryToOrganize_MessageFrame
        {
            public IOrganizeConnection conn { get; set; }
            public ArraySegment<byte>? messageFrame;


            public static DeliveryToOrganize_MessageFrame Pop()
            {
                return ObjectPool<DeliveryToOrganize_MessageFrame>.Shared.Pop();
            }

            /// <summary>
            /// 使用结束请手动调用
            /// </summary>
            public void Push()
            {
                conn = null;
                messageFrame = null;

                ObjectPool<DeliveryToOrganize_MessageFrame>.Shared.Push(this);
            }

        }


        class DeliveryToOrganize_RequestInfo
        {
            public IOrganizeConnection conn { get; set; }

            public long reqKey; 
            public static DeliveryToOrganize_RequestInfo Pop()
            {
                return ObjectPool<DeliveryToOrganize_RequestInfo>.Shared.Pop();
            }

            /// <summary>
            /// 使用结束请手动调用
            /// </summary>
            public void Push()
            {
                conn = null;
                ObjectPool<DeliveryToOrganize_RequestInfo>.Shared.Push(this);
            }
        }
        #endregion

        #endregion
        


        #region DeliveryToOrganize_ProcessFrame
        void DeliveryToOrganize_ProcessFrame(DeliveryToOrganize_MessageFrame msgFrame)
        {
            IOrganizeConnection conn = msgFrame.conn;
            var messageFrame = msgFrame.messageFrame;

            msgFrame.Push();

            if (messageFrame == null) return;

            var data = messageFrame.Value;

            if (data.Count <= 2) return;

            EFrameType msgType = (EFrameType)data.Array[data.Offset];

            var msgData = data.Slice(2);
            switch (msgType)
            {
                case EFrameType.reply:
                    {
                        UnpackReqRepFrame(msgData, out long reqKey, out var replyData);

                        if (OrganizeToDelivery_RequestMap_TryRemove(reqKey, out var requestInfo))
                        {
                            requestInfo.callback(requestInfo.sender, new Vit.Core.Util.Pipelines.ByteData(replyData));                         
                        }
                        return;
                    }
                case EFrameType.request:
                    {
                        byte requestType = data.Array[data.Offset + 1];

                        var reqInfo = DeliveryToOrganize_RequestInfo.Pop();
                        reqInfo.conn = conn;
                        UnpackReqRepFrame(msgData, out reqInfo.reqKey, out var requestData);

                        DeliveryToOrganize_OnGetRequest(reqInfo, requestType, requestData);
                        return;
                    }
                case EFrameType.message:
                    {
                        event_OnGetMessage?.Invoke(conn, msgData);
                        return;
                    }
                default:
                    conn.Close();
                    return;
            }
        }
        #endregion


        #region DeliveryToOrganize_OnGetRequest

        const string organizeVersion = "Sers.Mq.Socket.v1";
        
        void DeliveryToOrganize_OnGetRequest(DeliveryToOrganize_RequestInfo reqInfo, byte requestType, ArraySegment<byte> requestData)
        {
            switch ((ERequestType)requestType)
            {
                case ERequestType.app:
                    {
                        //app
                        event_OnGetRequest(reqInfo.conn,reqInfo, requestData, DeliveryToOrganize_SendReply);
                        return;
                    }
                case ERequestType.heartBeat:
                    {
                        var version = requestData.ArraySegmentByteToString();
                        if (version == organizeVersion)
                        {
                            // send reply
                            DeliveryToOrganize_SendReply(reqInfo, new Vit.Core.Util.Pipelines.ByteData(requestData));
                        }
                        else
                        {
                            // send reply
                            DeliveryToOrganize_SendReply(reqInfo, new Vit.Core.Util.Pipelines.ByteData ("error".SerializeToArraySegmentByte()));
                        }
                        return;
                    }
            }
        }
        #endregion

               
        #region DeliveryToOrganize_SendReply
        private void DeliveryToOrganize_SendReply(object sender, Vit.Core.Util.Pipelines.ByteData replyData)
        {
            DeliveryToOrganize_RequestInfo reqInfo = sender as DeliveryToOrganize_RequestInfo;
            var conn = reqInfo.conn;
            var reqKey = reqInfo.reqKey;
            reqInfo.Push();

            PackageReqRepFrame(reqKey, replyData, out var repFrame);

            Delivery_SendFrameAsync(conn, (byte)EFrameType.reply,0, repFrame);
        }

        #endregion


        #endregion



        #region (x.4)OrganizeToDelivery


        #region (x.x.1)organizeToDelivery_RequestMap

        DateTime organizeToDelivery_RequestMap_timeoutTime = DateTime.Now;
        bool organizeToDelivery_RequestMap_curIsMap0 = true;


        //organizeToDelivery_RequestMap
        //加一个缓冲区 定期 清理 无回应数据
        readonly ConcurrentDictionary<long, OrganizeToDelivery_RequestInfo> organizeToDelivery_RequestMap0 = new ConcurrentDictionary<long, OrganizeToDelivery_RequestInfo>();
        readonly ConcurrentDictionary<long, OrganizeToDelivery_RequestInfo> organizeToDelivery_RequestMap1 = new ConcurrentDictionary<long, OrganizeToDelivery_RequestInfo>();

        bool OrganizeToDelivery_RequestMap_TryRemove(long guid, out OrganizeToDelivery_RequestInfo reqInfo)
        {
            return (guid > 0 ? organizeToDelivery_RequestMap0 : organizeToDelivery_RequestMap1).TryRemove(guid, out reqInfo);
        }


        void OrganizeToDelivery_RequestMap_Set(ref long guid, OrganizeToDelivery_RequestInfo reqInfo)
        {
            if (organizeToDelivery_RequestMap_timeoutTime < DateTime.Now)
            {
                lock (organizeToDelivery_RequestMap0)
                {
                    if (organizeToDelivery_RequestMap_timeoutTime < DateTime.Now)
                    {
                        if (organizeToDelivery_RequestMap_curIsMap0)
                        {
                            organizeToDelivery_RequestMap1.Clear();
                            organizeToDelivery_RequestMap_curIsMap0 = false;
                        }
                        else
                        {
                            organizeToDelivery_RequestMap0.Clear();
                            organizeToDelivery_RequestMap_curIsMap0 = true;
                        }
                        organizeToDelivery_RequestMap_timeoutTime = DateTime.Now.AddMilliseconds(requestTimeoutMs);
                    }
                }
            }
            if (organizeToDelivery_RequestMap_curIsMap0)
            {
                organizeToDelivery_RequestMap0[guid] = reqInfo;
            }
            else
            {
                guid *= -1;
                organizeToDelivery_RequestMap1[guid] = reqInfo;
            }
        }




        #region class OrganizeToDelivery_RequestInfo       
        class OrganizeToDelivery_RequestInfo
        {
            public object sender;
            public Action<object, Vit.Core.Util.Pipelines.ByteData> callback;
        };
        #endregion

        #endregion

        #endregion


        #region (x.5)Delivery_SendFrameAsync        
        void Delivery_SendFrameAsync(IOrganizeConnection conn, byte msgType, byte requestType, Vit.Core.Util.Pipelines.ByteData data)
        {
            //var item = DataPool.BytesGet(2);
            var item = new byte[2];
            item[0] = msgType;
            item[1] = requestType;
            data.Insert(0, new ArraySegment<byte>(item, 0, 2));
            conn.GetDeliveryConn()?.SendFrameAsync(data);
        }
        #endregion




        #region (x.6)HeartBeat

        readonly SersTimer heartBeat_Timer = new SersTimer();

        void HeartBeat_Loop()
        {
            try
            {
                var temp = HeartBeat_info_cur;
                HeartBeat_info_cur = HeartBeat_info_Before;
                HeartBeat_info_Before = temp;
                var conns = GetConnList();
                if (conns != null)
                    foreach (var conn in conns)
                    {
                        try
                        {
                            HeartBeat_CheckIfDisconnectedAndSendHeartBeat(conn);
                        }
                        catch (Exception ex) when (!(ex.GetBaseException() is ThreadInterruptedException))
                        {
                            Logger.Error(ex);
                        }
                    }
                HeartBeat_info_Before.Clear();
            }
            catch (Exception ex) when (!(ex.GetBaseException() is ThreadInterruptedException))
            {
                Logger.Error(ex);
            }
        }


        static readonly byte[] organizeVersion_ba = organizeVersion.SerializeToBytes();
        static Vit.Core.Util.Pipelines.ByteData HeartBeat_Data => new ByteData(organizeVersion_ba);

        class HeartBeatInfo
        {
            public readonly List<HeartBeatPackage> list = new List<HeartBeatPackage>();

            public bool IsDisconnected(int heartBeatRetryCount)
            {
                while (list.Count > 0 && list[0].timeouted == false)
                {
                    list.RemoveAt(0);
                }

                int timeoutCount = 0;
                int curIndex = 0;
                while (curIndex < list.Count)
                {
                    var timeouted = list[curIndex].timeouted;
                    if (timeouted == false)
                    {
                        list.RemoveRange(0, curIndex + 1);
                        curIndex = 0;
                        timeoutCount = 0;
                    }
                    else if (timeouted == true)
                    {
                        timeoutCount++;
                        curIndex++;
                        if (timeoutCount >= heartBeatRetryCount) return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                return false;
            }
       
        }



        class HeartBeatPackage
        {
            public DateTime timeoutTime;
            public DateTime? replyTime;
            public IOrganizeConnection  conn;

            /// <summary>
            /// 是否超时  true:已经超时  false:未超时   null:未知
            /// </summary>
            public bool? timeouted
            {
                get
                {
                    if (replyTime != null)
                    {
                        return timeoutTime <= replyTime.Value ;
                    }

                    if (timeoutTime <= DateTime.Now) return true;
                    return null;
                }
            }
        }
        Dictionary<IOrganizeConnection , HeartBeatInfo> HeartBeat_info_Before = new Dictionary<IOrganizeConnection , HeartBeatInfo>();
        Dictionary<IOrganizeConnection , HeartBeatInfo> HeartBeat_info_cur = new Dictionary<IOrganizeConnection , HeartBeatInfo>();
        void HeartBeat_CheckIfDisconnectedAndSendHeartBeat(IOrganizeConnection conn)
        {
            if (HeartBeat_info_Before.TryGetValue(conn, out var info))
            {
                if (info.IsDisconnected(heartBeatRetryCount))
                {
                    Logger.Info("[CL.RequestAdaptor]HeartBeat,conn disconnected. connTag:" + conn.connTag);
                    conn.Close();                    
                    return;
                }
            }
            else
            {
                info = new HeartBeatInfo();
            } 

            info.list.Add(HeartBeat_Send(conn));

            HeartBeat_info_cur[conn] = info;             

        }

        HeartBeatPackage HeartBeat_Send(IOrganizeConnection conn)
        {
            var p = new HeartBeatPackage() { timeoutTime = DateTime.Now.AddMilliseconds(heartBeatTimeoutMs), conn = conn };
            SendRequestAsync(conn, p, HeartBeat_Data, HeartBeat_callback, ERequestType.heartBeat);
            return p;
        }

        void HeartBeat_callback(object sender,Vit.Core.Util.Pipelines.ByteData replyData)
        {
            HeartBeatPackage package = sender as HeartBeatPackage;

            //if (organizeVersion != replyData?.ByteDataToString())
            //{
            //    var deliveryConn = package.conn.GetDeliveryConn();                
            //    if (deliveryConn != null)
            //    {
            //        Logger.Info("[CL.RequestAdaptor]HeartBeat_callback,CL Version not match,will stop conn. connTag:" + package.conn.connTag + "  replyData:" + replyData.ByteDataToString());
            //        Task.Run((Action) deliveryConn.Close);
            //    }
            //    return;
            //}           
            package.replyTime = DateTime.Now;
        }


        #endregion



        #region (x.7)ReqRepFrame Pack  Unpack
        /*
                    //ReqRepFrame 消息帧(byte[])	 
                    第1部分： 请求标识（reqKey）(long)			长度为8字节
                    第2部分： 消息内容(oriMsg)
        */
        internal static void UnpackReqRepFrame(ArraySegment<byte> reqRepFrame, out long reqKey, out ArraySegment<byte> oriMsg)
        {
            //第1帧            
            reqKey = reqRepFrame.Slice(0, 8).ArraySegmentByteToInt64();

            //第2帧
            oriMsg = reqRepFrame.Slice(8);
        }

        /// <summary>
        /// 注：调用后，不改变oriMsg
        /// </summary>
        /// <param name="reqKey"></param>
        /// <param name="oriMsg"></param>
        /// <param name="reqRepFrame"></param>
        static void PackageReqRepFrame(long reqKey, Vit.Core.Util.Pipelines.ByteData oriMsg, out Vit.Core.Util.Pipelines.ByteData reqRepFrame)
        {
            //*
            reqRepFrame = new ByteData();

            //第1帧 reqKey
            reqRepFrame.Add(reqKey.Int64ToBytes().BytesToArraySegmentByte());

            //第2帧
            if (null != oriMsg) reqRepFrame.AddRange(oriMsg);

            /*/
            reqRepFrame = oriMsg ?? new ByteData();

            //reqKey
            reqRepFrame.Insert(0, reqKey.Int64ToBytes().BytesToArraySegmentByte());
            //*/
        }


        #endregion



    }
}
