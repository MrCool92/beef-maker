using System;
using GLFW;
using ImGui;

namespace BeefMakerEngine
{
    public class WindowsWindow : Window
    {
        private static int windowWidth = 1280;
        private static int windowHeight = 720;
        private static bool vsyncEnabled;

        private GlfwWindow* window;

        private WindowData windowData;

        public struct WindowData
        {
            public String name;
            public int width;
            public int height;
            public bool vsync;
        }

        public override bool Initialize()
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
            Glfw.SetWindowUserPointer(window, &windowData);

            Glfw.MakeContextCurrent(window);
            GL.Init( => Glfw.GetProcAddress);
            Glfw.SetFramebufferSizeCallback(window, new => FramebufferResizeCallback);

            // Show window
            Glfw.ShowWindow(window);

            InitImGui();

            return true;
        }

        private void InitImGui()
        {
            ImGui.CHECKVERSION();
            ImGui.CreateContext();

            ImGui.IO* io = ImGui.GetIO();
            io.DisplaySize = .(windowWidth, windowHeight);
            io.DisplayFramebufferScale = .(1.0f, 1.0f);
            io.ConfigFlags |= .NavEnableKeyboard | .DockingEnable | .ViewportsEnable;

            io.IniFilename = null;

            io.Fonts.AddFontFromFileTTF("../data/fonts/Roboto-Regular.ttf", 16);

            ImGuiImplGlfw.InitForOpenGL(window, true);
            ImGuiImplOpenGL3.Init("#version 130");
        }

        public override void Shutdown()
        {
            ImGuiImplOpenGL3.Shutdown();
            ImGuiImplGlfw.Shutdown();
            ImGui.DestroyContext();

            Glfw.DestroyWindow(window);
            Glfw.Terminate();
        }

        public override void BeginImGUI()
        {
            //ClearColor(0.118f, 0.118f, 0.118f, 1f);

            ImGuiImplOpenGL3.NewFrame();
            ImGuiImplGlfw.NewFrame();
            ImGui.NewFrame();
        }

        public override void EndImGUI()
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

        public override void PollEvents()
        {
            Glfw.PollEvents();

            for (var keyValue in Enum.GetValues(typeof(KeyCode)))
            {
                if (keyValue == -1)
                    continue;

                var action = Glfw.GetKey(window, (GLFW.GlfwInput.Key)keyValue);
                var currentState = Input.[Friend]GetKeyState((KeyCode)keyValue);

                KeyState newState = .None;
                switch (action)
                {
                case .Press,.Repeat:
                    newState = (currentState == .None || currentState == .Released) ? .Pressed : .Held;

                case .Release:
                    newState = (currentState == .Pressed || currentState == .Held) ? .Released : .None;
                }

                Input.[Friend]SetKeyState((KeyCode)keyValue, newState);
            }
        }

        public KeyState ActionToKeyState(GLFW.GlfwInput.Action action)
        {
            switch (action)
            {
            case .Press: return .Pressed;
            case .Release: return .Released;
            case .Repeat: return .Held;
            default: return .None;
            }
        }

        public override bool ShouldWindowClose()
        {
            return Glfw.WindowShouldClose(window);
        }

        public override void SetVSync(bool enabled)
        {
            Glfw.SwapInterval(enabled ? 1 : 0);
            vsyncEnabled = enabled;
        }

        public void ClearColor(float red, float green, float blue, float alpha)
        {
            GL.glClearColor(red, green, blue, alpha);
            GL.glClear(GL.GL_COLOR_BUFFER_BIT);
        }

        public void GetWindowSize(out int width, out int height)
        {
            width = height = 0;
            Glfw.GetWindowSize(window, ref width, ref height);
        }

        private void FramebufferResizeCallback(GlfwWindow* window, int width, int height)
        {
            var windowData = (WindowData*)Glfw.GetWindowUserPointer(window);
            windowData.width = width;
            windowData.height = height;
            OnWindowResize(width, height);
        }
    }
}