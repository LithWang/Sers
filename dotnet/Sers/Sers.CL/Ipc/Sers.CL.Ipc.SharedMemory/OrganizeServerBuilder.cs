﻿using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using Sers.Core.CL.MessageOrganize;
using Sers.Core.CL.MessageOrganize.DefaultOrganize;
using Vit.Extensions;

namespace Sers.CL.Ipc.SharedMemory
{
    public class OrganizeServerBuilder : IOrganizeServerBuilder
    {
        public void Build(List<IOrganizeServer> organizeList, JObject config)
        {
            var connConfig = config.ConvertBySerialize<ConnConfig>();

            var delivery = new DeliveryServer();

            delivery.name = connConfig.name;
            delivery.nodeCount = connConfig.nodeCount;
            delivery.nodeBufferSize = connConfig.nodeBufferSize;

            organizeList.Add(new OrganizeServer(delivery, config));
        }

         
    }
}