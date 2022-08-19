using System;
using GLFW;

namespace BeefMaker
{
	class GLFW
	{
		private GlfwWindow* window;

		public Result<void> Init()
		{
			if (!Glfw.Init())
			{
				Console.WriteLine("Failed to initialized GLFW!");
				return .Err;
			}

			int major = 0;
			int minor = 0;
			int rev = 0;
			Glfw.GetVersion(ref major, ref minor, ref rev);
			Console.WriteLine("Initialized GLFW {}.{}.{}", major, minor, rev);

			// Set error callback
			Glfw.SetErrorCallback(new (error, description) => Console.WriteLine("Error {}: {}", error, description));

			// Get monitors
			int monitorCount = 0;
			GlfwMonitor** monitors = Glfw.GetMonitors(ref monitorCount);

			for (int i < monitorCount) {
				String name = scope .();
				Glfw.GetMonitorName(monitors[i], name);

				GlfwVideoMode* videoMode = Glfw.GetVideoMode(monitors[i]);
				Console.WriteLine("Monitor {}: '{}' {}x{}", i, name, videoMode.width, videoMode.height);
			}

			// Set window hints and create window
			Glfw.WindowHint(.Visible, false);
			Glfw.WindowHint(.ClientApi, Glfw.ClientApi.OpenGlApi);
			Glfw.WindowHint(.ContextVersionMajor, 3);
			Glfw.WindowHint(.ContextVersionMinor, 3);

			window = Glfw.CreateWindow(1280, 720, Application.windowTitle, null, null);

			Glfw.MakeContextCurrent(window);

			// Set key callback
			Glfw.SetKeyCallback(window, new (window, key, scancode, action, mods) => {
				if (key == .Escape && action == .Press) Glfw.SetWindowShouldClose(window, true);
			});

			// Show window
			Glfw.ShowWindow(window);

			return .Ok;
		}

		public void SwapBuffers()
		{
			Glfw.SwapBuffers(window);
		}

		public bool WindowShouldClose()
		{
			return Glfw.WindowShouldClose(window);
		}

		public void Terminate()
		{
			// Destroy window and terminate GLFW
			Glfw.DestroyWindow(window);
			Glfw.Terminate();
		}
	}
}