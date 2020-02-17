﻿using Vit.Core.Module.Log;
using System;
using Vit.Extensions;

namespace Sers.Core.Module.PubSub.Controller
{
    public abstract class SubscriberController<T> : ISubscriberController
    {
        public SubscriberController(string msgTitle)
        {
            this.msgTitle= msgTitle;
        }

        public string msgTitle { get; protected set; }


        public void OnGetMessage(ArraySegment<byte> msgBody)
        {
            T t;
            try
            {
                t= msgBody.DeserializeFromArraySegmentByte<T>();
            }
            catch (Exception ex)
            {
                Logger.Error(ex);
                return;
                //t = default(T);
            }

            try
            {
                Handle(t);
            }
            catch (Exception ex)
            {
                Logger.Error(ex);
            }

        }


        public abstract void Handle(T msgBody);

      
    }
}
