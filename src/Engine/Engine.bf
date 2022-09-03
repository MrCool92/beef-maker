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

				double currentDeltaTime = Time.DeltaTime;
				while (Time.Time + Time.epsilon >= nextFixedTime)
				{
					Time.[Friend]deltaTime = Time.FixedTimestep;
					for (var m in moduleStack)
						m.OnFixedUpdate();

					nextFixedTime += Time.FixedTimestep;
				}

				Time.[Friend]deltaTime = currentDeltaTime;
				for (var m in moduleStack)
					m.OnUpdate();

				GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, 0);
				platform.BeginGUI();

				for (var m in moduleStack)
					m.OnGUI();

				platform.EndGUI();

				bool shouldStopRunning = isQuitting || platform.WindowShouldClose();
				isRunning = moduleStack.Count > 0 && !shouldStopRunning;
			}
		}

		public static void Quit()
		{
			isQuitting = true;
		}
	}
}