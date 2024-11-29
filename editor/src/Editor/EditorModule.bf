using ImGui;
using System;
using BeefMakerEngine;

namespace BeefMakerEditor
{
    public class EditorModule : Module
    {
        private bool showDemoWindow = true;

        private RenderTexture sceneRenderTexture ~ delete _;
        private Mesh triangleMesh ~ delete _;
        private Shader shader ~ delete _;
        private Camera camera ~ delete _;

        private Vector2 gameWindowSize;
        private bool recreateRenderTexture;

        public Event<delegate void()> OnGameWindowSizeChanged;

        private float hue;
        private Box boxObject ~ delete _;

        private GameView gameView;
        private SceneView sceneView;

        public override void OnEnable()
        {
            gameView = new GameView();
            sceneView = new SceneView();

            sceneRenderTexture = new RenderTexture(1024, 768);

            var vertices = new float[3 * 3](
                -0.5f, -0.5f, 0.0f,
                0.5f, -0.5f, 0.0f,
                0.0f,  0.5f, 0.0f
                );
            var indicies = new uint32[3](0, 1, 2);
            triangleMesh = new Mesh(vertices, indicies);
            shader = new Shader("../data/shaders/basic.shader");

            ImGuiTheme.Init();

            camera = new Camera(Vector3.zero, .(0, 0, 1), Vector3.up);
            boxObject = new Box();
            boxObject.position = .(0, 0, 10);

            //OnGameWindowSizeChanged.Add(new => HandleGameWindowSizeChange);
        }

        /*private void HandleGameWindowSizeChange()
        {
            
        }*/

        public override void OnDisable()
        {
        }

        public override void OnFixedUpdate()
        {
        }

        public override void OnUpdate()
        {
            Clear();

            if (recreateRenderTexture)
            {
                recreateRenderTexture = false;
                camera.aspectRatio = gameWindowSize.x / gameWindowSize.y;
                delete sceneRenderTexture;
                sceneRenderTexture = new RenderTexture((int)gameWindowSize.x, (int)gameWindowSize.y);
            }

            sceneRenderTexture.Bind();
            defer sceneRenderTexture.Unbind();

            // Draw triangle on black background
            /*{
                sceneRenderTexture.Clear();
                shader.Bind();

                hue += 80 * (float)Time.DeltaTime;
                int r, g, b;
                Color.HsvToRgb(hue, 1, 1, out r, out g, out b);
                shader.SetUniform4f("uColor", r / 255f, g / 255f, b / 255f, 1.0f);
                triangleMesh.Render();

                shader.Unbind();
            }*/

            GL.glClearColor(1f, 1f, 1f, 1f);
            GL.glClear(GL.GL_COLOR_BUFFER_BIT);
            boxObject.Render(camera);

            if (Input.GetKey(.W))
                boxObject.Move(.(0, 1, 0));

            if (Input.GetKey(.S))
                boxObject.Move(.(0, -1, 0));

            if (Input.GetKey(.A))
                boxObject.Move(.(-1, 0, 0));

            if (Input.GetKey(.D))
                boxObject.Move(.(1, 0, 0));

            if (Input.GetKey(.X))
                boxObject.Move(.(0, 0, 1));

            if (Input.GetKey(.Q))
                camera.Move(.(0, 0, 1));

            if (Input.GetKey(.E))
                camera.Move(.(0, 0, -1));

            if (Input.GetKey(.T))
                camera.Move(.(0, 1, 0));

            if (Input.GetKey(.G))
                camera.Move(.(0, -1, 0));

            if (Input.GetKey(.F))
                camera.Move(.(-1, 0, 0));

            if (Input.GetKey(.H))
                camera.Move(.(1, 0, 0));
        }

        public override void OnGUI()
        {
            DockSpace();

            if (showDemoWindow)
                ImGui.ShowDemoWindow(&showDemoWindow);

            GameWindow();
        }

        private void Clear()
        {
            GL.glClearColor(0.118f, 0.118f, 0.118f, 1f);
            GL.glClear(GL.GL_COLOR_BUFFER_BIT);
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
                    var windowSize = ImGui.GetWindowSize();
                    ImGui.Image(sceneRenderTexture.TextureId, windowSize, ImGui.Vec2(0, 1), ImGui.Vec2(1, 0));

                    if (gameWindowSize.x != windowSize.x || gameWindowSize.y != windowSize.y)
                    {
                        gameWindowSize = windowSize;
                        recreateRenderTexture = true;
                        OnGameWindowSizeChanged();
                    }
                }

                ImGui.EndChild();
            }
            ImGui.End();
            ImGui.PopStyleVar();
        }

        public static void GLClearError()
        {
            while (GL.glGetError() != GL.GL_NO_ERROR) { }
        }

        public static bool GLLogCall(
            String file = Compiler.CallerFilePath,
            String member = Compiler.CallerMemberName,
            int line = Compiler.CallerLineNum)
        {
            let error = GL.glGetError();
            if (error != GL.GL_NO_ERROR)
            {
                Console.WriteLine($"[OpenGL_Error] {error} in {file} at {member}:{line}");
                return false;
            }
            return true;
        }

        public static void GLLogCall<T>(T x, String expr = Compiler.CallerExpression[0], String file = Compiler.CallerFileName, String member = Compiler.CallerMemberName, int line = Compiler.CallerLineNum)
            where T : delegate void()
        {
            GLClearError();
            x();
            let error = GL.glGetError();
            System.Diagnostics.Debug.Assert(error == GL.GL_NO_ERROR, scope $"{expr} in {file} at {member}:{line}");
        }
    }
}