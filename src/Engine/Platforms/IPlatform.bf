namespace BeefMaker
{
	public interface IPlatform
	{
		bool Init();
		void PollEvents();
		void BeginGUI();
		void EndGUI();
		bool WindowShouldClose();
		void Shutdown();
	}
}