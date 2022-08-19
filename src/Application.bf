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
				Glfw.PollEvents();

				glfw.SwapBuffers();
			}

			// Shutdown
			glfw.Terminate();

			return .Ok;
		}
	}
}