﻿using System.Collections.Generic;
using Sers.Core.Module.Api.Rpc;
using Sers.SersLoader;
using Sers.SersLoader.ApiDesc.Attribute.Valid;
using Sers.Gover.Base;
using Sers.Gover.Base.Model;
using Vit.Core.Util.ComponentModel.Api;
using Vit.Core.Util.ComponentModel.Data;
using Vit.Core.Util.ComponentModel.Model;

namespace Sers.Gover.Controller.ApiControllers
{
    [SsStationName("_gover_")]
    public class ServiceStationController : IApiController
    {
        /// <summary>
        /// 获取所有ServiceStation
        /// </summary>
        /// <returns></returns>
        [SsRoute("serviceStation/getAll")]
        [SsCallerSource(ECallerSource.Internal)]
        //[CallFromGover]
        [SsName("获取所有ServiceStation")]
        public ApiReturn<List<ServiceStationData>> GetAll()
        {
            return new ApiReturn<List<ServiceStationData>> { data = GoverManage.Instance.ServiceStation_GetAll() }; 
        }


        /// <summary>
        /// 暂停指定的服务站点
        /// </summary>
        /// <returns></returns>
        [SsRoute("serviceStation/pause")]
        [SsCallerSource(ECallerSource.Internal)]
        //[CallFromGover]
        [SsName("暂停指定的服务站点")]
        public ApiReturn Pause(string connKey)
        {
            return new ApiReturn { success = GoverManage.Instance.ServiceStation_Pause(connKey) };
        }

        /// <summary>
        /// 启用指定的服务站点
        /// </summary>
        /// <returns></returns>
        [SsRoute("serviceStation/start")]
        [SsCallerSource(ECallerSource.Internal)]
        //[CallFromGover]
        [SsName("启用指定的服务站点")]
        public ApiReturn Start(string connKey)
        {
            return new ApiReturn { success = GoverManage.Instance.ServiceStation_Start(connKey) };
        }
         


     




    }
}
