using System;

namespace BeefMakerEngine
{
    public class Engine
    {
        public static readonly String windowTitle = "Beef Maker";
        private static bool isQuitting;

        private Time time ~ delete _;
        private Window window ~ delete _;
        private ModuleStack moduleStack ~ delete _;
        private bool isRunning;

        public bool Init(String[] args, params Module[] modules)
        {
            time = new Time();
            window = new WindowsWindow();

            if (!window.Init())
                return false;

            Input.Initialize(window);

            moduleStack = new ModuleStack();
            for (var module in modules)
            {
                moduleStack.Push(module);
            }

            isRunning = true;
            return true;
        }

        public ~this()
        {
            window.Shutdown();
        }

        public void Run()
        {
            double nextFixedTime = 0;
            while (isRunning)
            {
                time.Update();

                window.PollEvents();

                float currentDeltaTime = Time.DeltaTime;
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

                for (var m in moduleStack)
                    m.OnRender();

                GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, 0);
                window.BeginGUI();

                for (var m in moduleStack)
                    m.OnGUI();

                window.EndGUI();

                bool shouldStopRunning = isQuitting || window.WindowShouldClose();
                isRunning = moduleStack.Count > 0 && !shouldStopRunning;
            }
        }

        public static void Quit()
        {
            isQuitting = true;
        }
    }
}