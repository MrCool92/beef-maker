using System;
using GLFW;
using ImGui;

namespace BeefMaker
{
	public class OpenGLPlatform : IPlatform
	{
		private static int windowWidth = 1280;
		private static int windowHeight = 720;

		private GlfwWindow* window;
		private delegate void(GlfwWindow* window, int width, int height) framebufferResizeCallbackDelegate = new => FramebufferResizeCallback;

		public bool Init()
		{
			if (!Glfw.Init())
			{
				Console.WriteLine("Failed to initialized GLFW!");
				return false;
			}

			int major = 0;
			int minor = 0;
			int rev = 0;
			Glfw.GetVersion(ref major, ref minor, ref rev);
			Console.WriteLine($"Initialized GLFW {major}.{minor}.{rev}");

			// Set error callback
			Glfw.SetErrorCallback(new (error, description) => Console.WriteLine($"Error {error}: {description}"));

			// Get monitors
			int monitorCount = 0;
			GlfwMonitor** monitors = Glfw.GetMonitors(ref monitorCount);

			for (int i < monitorCount)
			{
				String name = scope .();
				Glfw.GetMonitorName(monitors[i], name);

				GlfwVideoMode* videoMode = Glfw.GetVideoMode(monitors[i]);
				Console.WriteLine($"Monitor {i}: '{name}' {videoMode.width}x{videoMode.height}");
			}

			// Set window hints and create window
			Glfw.WindowHint(.Visible, false);
			Glfw.WindowHint(.ClientApi, Glfw.ClientApi.OpenGlApi);
			Glfw.WindowHint(.ContextVersionMajor, 3);
			Glfw.WindowHint(.ContextVersionMinor, 3);

			window = Glfw.CreateWindow(windowWidth, windowHeight, Engine.windowTitle, null, null);

			Glfw.MakeContextCurrent(window);
			GL.Init(=> Glfw.GetProcAddress);
			Glfw.SetFramebufferSizeCallback(window, framebufferResizeCallbackDelegate);

			// Set key callback
			/*Glfw.SetKeyCallback(window, new (window, key, scancode, action, mods) => {
				if (key == .Escape && action == .Press)
					Glfw.SetWindowShouldClose(window, true);
			});*/

			// Show window
			Glfw.ShowWindow(window);

			InitImGUI();

			return true;
		}

		private void InitImGUI()
		{
			ImGui.CHECKVERSION();
			ImGui.CreateContext();

			ImGui.IO* io = ImGui.GetIO();
			io.DisplaySize = .(windowWidth, windowHeight);
			io.DisplayFramebufferScale = .(1.0f, 1.0f);
			io.ConfigFlags |= .NavEnableKeyboard | .DockingEnable | .ViewportsEnable;

			ImGuiImplGlfw.InitForOpenGL(window, true);
			ImGuiImplOpenGL3.Init("#version 130");
		}

		public void Shutdown()
		{
			ImGuiImplOpenGL3.Shutdown();
			ImGuiImplGlfw.Shutdown();
			ImGui.DestroyContext();

			Glfw.DestroyWindow(window);
			Glfw.Terminate();
		}

		public void BeginGUI()
		{
			//ClearColor(0.118f, 0.118f, 0.118f, 1f);
			ImGuiImplOpenGL3.NewFrame();
			ImGuiImplGlfw.NewFrame();
			ImGui.NewFrame();
		}

		public void EndGUI()
		{
			ImGui.Render();
			ImGuiImplOpenGL3.RenderDrawData(ImGui.GetDrawData());
			if (ImGui.GetIO().ConfigFlags & .ViewportsEnable != 0)
			{
				GlfwWindow* lastContext = Glfw.GetCurrentContext();
				ImGui.UpdatePlatformWindows();
				ImGui.RenderPlatformWindowsDefault();
				Glfw.MakeContextCurrent(lastContext);
			}
			Glfw.SwapBuffers(window);
		}

		public void PollEvents()
		{
			Glfw.PollEvents();
		}

		public void GetWindowSize(out int width, out int height)
		{
			width = height = 0;
			Glfw.GetWindowSize(window, ref width, ref height);
		}

		public bool WindowShouldClose()
		{
			return Glfw.WindowShouldClose(window);
		}

		public void ClearColor(float red, float green, float blue, float alpha)
		{
			GL.glClearColor(red, green, blue, alpha);
			GL.glClear(GL.GL_COLOR_BUFFER_BIT);
		}

		private void FramebufferResizeCallback(GlfwWindow* window, int width, int height)
		{
			
		}
	}
}