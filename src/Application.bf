using System;
using GLFW;

namespace BeefMaker
{
	class Application
	{
		public static readonly String windowTitle = "Beef Maker";

		private GLFW glfw;

		public Result<void> Start()
		{
			// Init
			glfw = scope GLFW();
			glfw.Init();

			// Main Loop
			while (!glfw.WindowShouldClose())
			{
				glfw.BeginFrame();
				glfw.PollEvents();
				glfw.OnGUI();
				glfw.EndFrame();
			}

			// Shutdown
			glfw.Shutdown();

			return .Ok;
		}
	}
}