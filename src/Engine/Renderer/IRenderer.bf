namespace BeefMaker
{
	public interface IRenderer
	{
		bool Init();
		void PollEvents();
		void Render();
		bool WindowShouldClose();
		void Shutdown();
	}
}