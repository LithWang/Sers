﻿
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Hosting.Server;
using Microsoft.Extensions.DependencyInjection;
using Sers.Core.Module.Api.LocalApi;
using Sers.Serslot.Mode.Async;

namespace Vit.Extensions
{
    static partial class IWebHostBuilder_UseSerslot_Extensions
    {
        internal static IWebHostBuilder UseSerslot_Async(this IWebHostBuilder hostBuilder)
        {
            var server = new SerslotServer();
            server.InitPairingToken(hostBuilder);

            LocalApiServiceFactory.CreateLocalApiService = () => new Sers.Serslot.Mode.Async.LocalApiService(server);


            return hostBuilder.ConfigureServices(services =>
            {
                services.AddSingleton<IServer>((serviceProvider)=> {
                    server.serviceProvider = serviceProvider;
                    return server;
                });
            });


        }



    }
}
