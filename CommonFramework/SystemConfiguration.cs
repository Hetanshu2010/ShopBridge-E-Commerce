using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Text;

namespace CommonFramework
{
    public static class SystemConfiguration
    {
        public static String ConnectionString { get; set; }

        public static bool Load()
        {
            var configuation = GetConfiguration();
            ConnectionString = configuation.GetSection("ConnectionString").GetSection("ShopBridgeConn").Value;
            return true;
        }

        public static IConfigurationRoot GetConfiguration()
        {
            var builder = new ConfigurationBuilder().SetBasePath(Directory.GetCurrentDirectory()).AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
            return builder.Build();
        }
    }
}
