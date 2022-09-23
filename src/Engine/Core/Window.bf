namespace BeefMaker
{
	public abstract class Window
	{
		public abstract bool Init();
		public abstract void PollEvents();
		public abstract void BeginGUI();
		public abstract void EndGUI();
		public abstract bool WindowShouldClose();
		public abstract void Shutdown();
		public abstract void SetVSync(bool enabled);
	}
}