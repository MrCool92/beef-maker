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

        public bool Initialize(String[] args, params Module[] modules)
        {
            time = new Time();
            window = new WindowsWindow();
            window.OnWindowResize.Add(new => OnWindowResize);

            if (!window.Initialize())
                return false;

            Input.Initialize(window);
            PrimitiveObject.Initialize();
            SceneManager.Initialize();

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
            while (isRunning)
            {
                Logic();
            }
        }

        private void Logic()
        {
            double nextFixedTime = 0;

            Debug.Log(Time.DeltaTime);
            time.Update();
            TransformSystem.Update();

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
            for (var module in moduleStack)
                module.OnUpdate();

            for (var module in moduleStack)
                module.OnRender();

            GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, 0);
            window.BeginImGUI();

            for (var module in moduleStack)
                module.OnImGUI();

            window.EndImGUI();

            bool shouldStopRunning = isQuitting || window.ShouldWindowClose();
            isRunning = moduleStack.Count > 0 && !shouldStopRunning;
        }

        public static void Quit()
        {
            isQuitting = true;
        }

        private void OnWindowResize(int width, int height)
        {
            Debug.Log("Window resize!");
            Logic();
        }
    }
}