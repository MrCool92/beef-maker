using ImGui;
using System;

namespace BeefMaker
{
	public class Editor : Module
	{
		private bool showDemoWindow = true;

		public override void OnFixedUpdate()
		{
			Console.WriteLine($"FixedUpdate: {Time.deltaTime}");
		}

		public override void OnUpdate()
		{
			Console.WriteLine($"Update: {Time.deltaTime}");
		}

		public override void OnGUI()
		{
			DockSpace();

			if (showDemoWindow)
				ImGui.ShowDemoWindow(&showDemoWindow);
		}

		private void DockSpace()
		{
			ImGui.WindowFlags windowFlags =
				.MenuBar | .NoDocking | .NoSavedSettings |
				.NoTitleBar | .NoCollapse | .NoResize |
				.NoMove | .NoBringToFrontOnFocus | .NoNavFocus;

			ImGui.Viewport* viewport = ImGui.GetMainViewport();
			ImGui.SetNextWindowPos(viewport.WorkPos);
			ImGui.SetNextWindowSize(viewport.WorkSize);
			ImGui.SetNextWindowViewport(viewport.ID);
			ImGui.PushStyleVar(.WindowRounding, 0f);
			ImGui.PushStyleVar(.WindowBorderSize, 0);
			ImGui.PushStyleVar(.FrameBorderSize, 0);
			ImGui.PushStyleVar(.WindowPadding, .(0f, 0f));

			ImGui.Begin("MainViewport", null, windowFlags);
			ImGui.PopStyleVar(4);

			uint32 dockspaceId = ImGui.GetID("DockSpace");
			ImGui.DockSpace(dockspaceId, .(0f, 0f), .None);
			MenuBar();
			ImGui.End();
		}

		private void MenuBar()
		{
			if (ImGui.BeginMenuBar())
			{
			    if (ImGui.BeginMenu("File"))
			    {
					if (ImGui.MenuItem("Exit", "", false))
					{
						Engine.Quit();
					}

					ImGui.EndMenu();
				}
				ImGui.EndMenuBar();
			}
		}
	}
}