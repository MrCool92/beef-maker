using System;

namespace BeefMaker
{
	class Program
	{
		public static int Main(String[] args)
		{
			Engine engine = scope Engine();
			if (!engine.Init(args))
				return 1;

			engine.Run();
			return 0;
		}
	}
}