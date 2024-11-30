using System;
using BeefMakerEngine;

namespace BeefMakerEditor
{
    public class Program
    {
        public static int Main(String[] args)
        {
            var engine = scope Engine();
            if (!engine.Init(args, new EditorModule()))
                return 1;

            engine.Run();
            return 0;
        }
    }
}