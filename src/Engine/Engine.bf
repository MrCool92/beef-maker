using System;

namespace BeefMaker
{
	public class Engine
	{
		public static readonly String windowTitle = "Beef Maker";

		private Time time ~ delete _;
		private IRenderer renderer ~ delete _;
		private bool isRunning;

		public bool Init(String[] args)
		{
			time = new Time();
			renderer = new OpenGLRenderer();

			if (!renderer.Init())
				return false;

			isRunning = true;
			return true;
		}

		public void Run()
		{
			double nextFixedTime = 0;
			while (isRunning)
			{
				time.Update();

				renderer.PollEvents();

				double currentDeltaTime = Time.deltaTime;
				while (Time.time >= nextFixedTime)
				{
					Time.[Friend]_deltaTime = Time.fixedTimestep;
					FixedUpdate();
					nextFixedTime += Time.fixedTimestep;
				}

				Time.[Friend]_deltaTime = currentDeltaTime;
				Update();

				renderer.Render();

				isRunning = isRunning && !renderer.WindowShouldClose();
			}
		}

		private void FixedUpdate()
		{
			Console.WriteLine($"FixedUpdate: {Time.deltaTime}");
		}

		private void Update()
		{
			Console.WriteLine($"Update: {Time.deltaTime}");
		}

		public ~this() 
		{
			renderer.Shutdown();
		}
	}
}