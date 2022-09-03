#pragma warning disable 168
using ImGui;
using System;

namespace BeefMaker
{
	public class Editor : Module
	{
		private bool showDemoWindow = true;

		private RenderTexture sceneRenderTexture ~ delete _;
		private Mesh mesh ~ delete _;
		private Shader shader ~ delete _;

		public class Texture2D
		{
			private uint32 rendererId;

			this(int width, int height)
			{
				GL.glGenTextures(1, &rendererId);
				GL.glBindTexture(GL.GL_TEXTURE_2D, rendererId);

				GL.glTexImage2D(GL.GL_TEXTURE_2D, 0, GL.GL_RGB, width, height, 0, GL.GL_RGB, GL.GL_UNSIGNED_BYTE, null);

				GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
				GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);

				GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
				GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);
			}

			~this()
			{
				GL.glDeleteTextures(1, &rendererId);
			}
		}

		public override void OnEnable()
		{
			sceneRenderTexture = new RenderTexture(1024, 768);

			var vertices = new float[3 * 3] (
				-0.5f, -0.5f, 0.0f,
				 0.5f, -0.5f, 0.0f,
				 0.0f,  0.5f, 0.0f
			);
			var indicies = new uint32[3] ( 0, 1, 2 );
			mesh = new Mesh(vertices, indicies);
			shader = new Shader("data/shaders/basic.shader");

			ImGuiTheme.Init();
		}

		public override void OnDisable()
		{
			
		}

		public override void OnFixedUpdate()
		{
			//Console.WriteLine($"FixedUpdate: {Time.DeltaTime}");
		}

		public override void OnUpdate()
		{
			//Console.WriteLine($"Update: {Time.DeltaTime}");

			GL.glClearColor(0.118f, 0.118f, 0.118f, 1f);
			GL.glClear(GL.GL_COLOR_BUFFER_BIT);

			sceneRenderTexture.Bind();
			GL.glClearColor(0f, 0f, 0f, 1f);
			GL.glClear(GL.GL_COLOR_BUFFER_BIT);

			shader.Use();
			mesh.Render();
		}

		public override void OnGUI()
		{
			DockSpace();

			if (showDemoWindow)
				ImGui.ShowDemoWindow(&showDemoWindow);

			GameWindow();
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

		private void GameWindow()
		{
			ImGui.PushStyleVar(.WindowPadding, .(2f, 2f));
			ImGui.Begin("GameWindow");
			{
				ImGui.BeginChild("GameRender");
				{
					ImGui.Vec2 wsize = ImGui.GetWindowSize();
					ImGui.Image(sceneRenderTexture.TextureId, wsize, ImGui.Vec2(0, 1), ImGui.Vec2(1, 0));
				}
				ImGui.EndChild();
			}
			ImGui.End();
			ImGui.PopStyleVar();
		}
	}
}