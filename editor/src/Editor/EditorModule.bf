using ImGui;
using System;
using System.Diagnostics;

namespace BeefMakerEngine
{
    public class EditorModule : Module
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

        private float hue;

        public override void OnEnable()
        {
            sceneRenderTexture = new RenderTexture(1024, 768);

            var vertices = new float[3 * 3](
                -0.5f, -0.5f, 0.0f,
                0.5f, -0.5f, 0.0f,
                0.0f,  0.5f, 0.0f
                );
            var indicies = new uint32[3](0, 1, 2);
            mesh = new Mesh(vertices, indicies);
            shader = new Shader("../data/shaders/basic.shader");

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
            Clear();

            sceneRenderTexture.Bind();
            sceneRenderTexture.Clear();
            shader.Bind();

            hue += 80 * (float)Time.DeltaTime;
            int r, g, b;
            Color.HsvToRgb(hue, 1, 1, out r, out g, out b);
            shader.SetUniform4f("uColor", r / 255f, g / 255f, b / 255f, 1.0f);
            mesh.Render();

            shader.Unbind();
            sceneRenderTexture.Unbind();
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
                    ImGui.Vec2 wsize = ImGui.GetWindowSize();
                    ImGui.Image(sceneRenderTexture.TextureId, wsize, ImGui.Vec2(0, 1), ImGui.Vec2(1, 0));
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
            Debug.Assert(error == GL.GL_NO_ERROR, scope $"{expr} in {file} at {member}:{line}");
        }
    }
}