﻿using Vit.Core.Module.Log;
using Vit.Core.Util.ConfigurationManager;
using System;

namespace Vit.Extensions
{
    public static partial class LogMngExtensions
    { 

        public static void InitByConfigurationManager(this LogMng data)
        {
            if (false != ConfigurationManager.Instance.GetByPath<bool?>("Vit.Logger.PrintToTxt"))
            {
                Logger.OnLog += Logger.log.LogTxt;
            }


            if (false != ConfigurationManager.Instance.GetByPath<bool?>("Vit.Logger.PrintToConsole"))
            {
                Logger.OnLog += (level, msg)=> { Console.WriteLine("[" + level + "]" + DateTime.Now.ToString("[HH:mm:ss.ffff]") + msg);   };
            }
        }



    }
}
