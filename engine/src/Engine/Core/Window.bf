namespace BeefMakerEngine
{
    public abstract class Window
    {
        public abstract bool Init();
        public abstract void PollEvents();
        public abstract void BeginImGUI();
        public abstract void EndImGUI();
        public abstract bool ShouldWindowClose();
        public abstract void Shutdown();
        public abstract void SetVSync(bool enabled);
    }
}