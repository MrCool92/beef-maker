using System;

namespace BeefMaker
{
	class Program
	{
		public static int Main(String[] args)
		{
			Application application = scope Application();
			let result = application.Start();
			switch (result)
			{
				case .Ok: Console.WriteLine("Application exited with joy C:");
				case .Err: Console.WriteLine("Application exited with sadness :'(");
			}
			Console.Read();
			return 0;
		}
	}
}