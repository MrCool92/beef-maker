using System;

namespace BeefMakerEngine
{
    public abstract class Window
    {
        public Event<delegate void(int width, int height)> OnWindowResize = default;

        public abstract bool Initialize();
        public abstract void PollEvents();
        public abstract void BeginImGUI();
        public abstract void EndImGUI();
        public abstract bool ShouldWindowClose();
        public abstract void Shutdown();
        public abstract void SetVSync(bool enabled);
    }
}