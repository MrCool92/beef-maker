using System;

namespace BeefMakerEngine
{
    public class Debug
    {
/*#if !DEBUG
        [SkipCall]
        #endif*/
        public static void Log(Object obj)
        {
            System.Console.WriteLine(obj);
        }
    }
}