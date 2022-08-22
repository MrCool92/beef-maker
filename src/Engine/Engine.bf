using System;

namespace BeefMaker
{
	public class Engine
	{
		public static readonly String windowTitle = "Beef Maker";
		private static bool isQuitting;

		private Time time ~ delete _;
		private IPlatform platform ~ delete _;
		private ModuleStack moduleStack ~ delete _;
		private bool isRunning;

		public bool Init(String[] args)
		{
			time = new Time();
			platform = new OpenGLPlatform();

			if (!platform.Init())
				return false;

			moduleStack = new ModuleStack();
			moduleStack.Push(new Editor());

			isRunning = true;
			return true;
		}
		
		public ~this() 
		{
			platform.Shutdown();
		}

		public void Run()
		{
			double nextFixedTime = 0;
			while (isRunning)
			{
				time.Update();

				platform.PollEvents();

				double currentDeltaTime = Time.deltaTime;
				while (Time.time + Time.epsilon >= nextFixedTime)
				{
					Time.[Friend]_deltaTime = Time.fixedTimestep;
					for (var m in moduleStack)
						m.OnFixedUpdate();

					nextFixedTime += Time.fixedTimestep;
				}

				Time.[Friend]_deltaTime = currentDeltaTime;
				for (var m in moduleStack)
					m.OnUpdate();

				platform.BeginGUI();

				for (var m in moduleStack)
					m.OnGUI();

				platform.EndGUI();

				isRunning = !isQuitting || (moduleStack.Count > 0 && !platform.WindowShouldClose());
			}
		}

		public static void Quit()
		{
			isQuitting = true;
		}
	}
}