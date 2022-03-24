﻿using System;
using System.IO;
using System.Linq;

using Vit.Extensions;

namespace Vit.Core.Module.Log.LogCollector
{
    public class TxtCollector : ILogCollector
    {
        [System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)]
        public void Write(LogMessage msg)
        {
            #region build log string
            string logString = DateTime.Now.ToString("[HH:mm:ss.ffff]") + msg.message + NewLine;

            if (msg.objs != null)
            {
                foreach (var obj in msg.objs)
                {
                    logString += obj.Serialize() + NewLine;
                }
            }
            #endregion

            Write(msg.level, logString);
        }





        public static string NewLine = Environment.NewLine;


        [System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)]
        public void Write(Level level, string message)
        {
            string filePath = GetLogPath(level);

            lock (string.Intern(filePath))
                File.AppendAllText(filePath, message);
        }


        #region Path

        /// <summary>
        /// log的BasePath
        /// </summary>
        public string BasePath { set => fileCache.SetBasePath(value); }



        LogFilePathCache fileCache = new LogFilePathCache();

        [System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)]
        private string GetLogPath(Level level)
        {
            return fileCache.GetPath(level);
        }
        #endregion



        #region class LogFilePathCache
        class LogFilePathCache
        {

            [System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)]
            public void SetBasePath(string path)
            {
                BasePath = path;
                directoryDate = DateTime.MinValue;
            }


            static string AppPath => AppContext.BaseDirectory;
            //static string AppPath => Path.GetDirectoryName(typeof(Logger).Assembly.Location);

            /// <summary>
            /// /Logs
            /// </summary>
            string BasePath = Path.Combine(AppPath, "Logs");


            DateTime directoryDate = DateTime.MinValue;

            string[] paths;

            [System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)]
            public LogFilePathCache()
            {
                Level[] vs = (Level[])Enum.GetValues(typeof(Level));
                var max = vs.Max((m) => (int)m);
                paths = new string[max + 1];

            }

            [System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)]
            public string GetPath(Level level)
            {
                if (DateTime.Now.Date != directoryDate)
                {
                    lock (this)
                    {
                        directoryDate = DateTime.Now.Date;

                        // path
                        //  /Logs/{yyyy-MM}/{yyyy-MM-dd}{level}.log         
                        var directoryPath = Path.Combine(BasePath, directoryDate.ToString("yyyy-MM"));
                        Directory.CreateDirectory(directoryPath);
                        foreach (Level l in Enum.GetValues(typeof(Level)))
                        {
                            paths[(int)l] = Path.Combine(directoryPath, directoryDate.ToString("[yyyy-MM-dd]") + l.ToString().ToLower() + ".log");
                        }
                    }
                }
                return paths[(int)level];
            }

        }
        #endregion





    }
}
