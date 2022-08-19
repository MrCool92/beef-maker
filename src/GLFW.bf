using System;
using GLFW;
using ImGui;

namespace BeefMaker
{
	class GLFW
	{
		private static int windowWidth = 1280;
		private static int windowHeight = 720;

		private GlfwWindow* window;
				private delegate void(GlfwWindow* window, int width, int height) framebufferResizeCallbackDelegate = new => FramebufferResizeCallback;
		private bool showDemoWindow = true;

		private bool isQuitting;

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

			window = Glfw.CreateWindow(windowWidth, windowHeight, Application.windowTitle, null, null);

			Glfw.MakeContextCurrent(window);
			GL.Init(=> Glfw.GetProcAddress);
			Glfw.SetFramebufferSizeCallback(window, framebufferResizeCallbackDelegate);

			// Set key callback
			Glfw.SetKeyCallback(window, new (window, key, scancode, action, mods) => {
				if (key == .Escape && action == .Press) Glfw.SetWindowShouldClose(window, true);
			});

			// Show window
			Glfw.ShowWindow(window);

			InitImGUI();

			return .Ok;
		}

		private void InitImGUI()
		{
			ImGui.CHECKVERSION();
			ImGui.CreateContext();

			ImGui.IO* io = ImGui.GetIO();
			io.DisplaySize = .(windowWidth, windowHeight);
			io.DisplayFramebufferScale = .(1.0f, 1.0f);
			io.ConfigFlags |= ImGui.ConfigFlags.NavEnableKeyboard;
			io.ConfigFlags |= ImGui.ConfigFlags.DockingEnable;
			io.ConfigFlags |= ImGui.ConfigFlags.ViewportsEnable;

			ImGuiImplGlfw.InitForOpenGL(window, true);
			ImGuiImplOpenGL3.Init("#version 130");
		}

		public void BeginFrame()
		{
			ClearColor(0.118f, 0.118f, 0.118f, 1f);

			ImGuiImplOpenGL3.NewFrame();
			ImGuiImplGlfw.NewFrame();
			ImGui.NewFrame();
		}

		public void EndFrame()
		{
			ImGui.Render();
			ImGuiImplOpenGL3.RenderDrawData(ImGui.GetDrawData());
			if(ImGui.GetIO().ConfigFlags & ImGui.ConfigFlags.ViewportsEnable != 0)
			{
				var mainWindowContext = window;
				ImGui.UpdatePlatformWindows();
				ImGui.RenderPlatformWindowsDefault();
				Glfw.MakeContextCurrent(mainWindowContext);
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
			return Glfw.WindowShouldClose(window) || isQuitting;
		}

		public void Shutdown()
		{
			ImGuiImplOpenGL3.Shutdown();
			ImGuiImplGlfw.Shutdown();
			ImGui.DestroyContext();

			Glfw.DestroyWindow(window);
			Glfw.Terminate();
		}

		public void ClearColor(float red, float green, float blue, float alpha)
		{
			GL.glClearColor(red, green, blue, alpha);
			GL.glClear(GL.GL_COLOR_BUFFER_BIT);
		}

		public void OnGUI()
		{
			DockSpace();

			if (showDemoWindow)
				ImGui.ShowDemoWindow(&showDemoWindow);
		}

		private void DockSpace()
		{
			ImGui.WindowFlags windowFlags = .MenuBar | .NoDocking | .NoSavedSettings;
			windowFlags |= .NoTitleBar | .NoCollapse | .NoResize |.NoMove;
			windowFlags |= .NoBringToFrontOnFocus | .NoNavFocus;

			var viewport = ImGui.GetMainViewport();
			ImGui.SetNextWindowPos(viewport.WorkPos);
			ImGui.SetNextWindowSize(viewport.WorkSize);
			ImGui.SetNextWindowViewport(viewport.ID);
			ImGui.PushStyleVar(.WindowRounding, 0.0f);
			ImGui.PushStyleVar(.WindowBorderSize, 1.0f);

			ImGui.PushStyleVar(.WindowPadding, .(0.0f, 0.0f));
			ImGui.Begin("MainViewport", null, windowFlags);
			ImGui.PopStyleVar(3);

			uint32 dockspaceId = ImGui.GetID("DockSpace");
			ImGui.DockSpace(dockspaceId, .(0.0f, 0.0f), .None);

			if (ImGui.BeginMenuBar())
			{
			    if (ImGui.BeginMenu("File"))
			    {
					if (ImGui.MenuItem("Exit", "", false))
					{
						isQuitting = true;
					}

					ImGui.EndMenu();
				}
				ImGui.EndMenuBar();
			}
			ImGui.End();
		}

		private void FramebufferResizeCallback(GlfwWindow* window, int width, int height)
		{
			Console.WriteLine($"Resize event: {width}, {height}");
		}
	}
}