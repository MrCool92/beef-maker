using ImGui;
using System;
using System.Collections;
using BeefMakerEngine;

namespace BeefMakerEditor
{
    public class EditorModule : Module
    {
        private bool showDemoWindow = true;

        private Camera camera ~ delete _;

        private GameView gameView ~ delete _;
        private Inspector inspector ~ delete _;

        private List<EditorWindow> editorWindows;

        public override void OnEnable()
        {
            ImGuiTheme.Init();

            camera = new Camera(Vector3.zero, .(0, 0, 1), Vector3.up);

            editorWindows = new List<EditorWindow>();

            gameView = new GameView();
            gameView.camera = camera;
            editorWindows.Add(gameView);

            inspector = new Inspector();
            editorWindows.Add(inspector);
        }

        public override void OnDisable()
        {
        }

        public override void OnFixedUpdate()
        {
        }

        public override void OnUpdate()
        {
            gameView.[Friend]Update();
        }

        public override void OnRender()
        {
            gameView.[Friend]Render();
        }

        public override void OnGUI()
        {
            Clear();

            DockSpace();

            if (showDemoWindow)
                ImGui.ShowDemoWindow(&showDemoWindow);

            gameView.[Friend]GUI();
            inspector.[Friend]GUI();
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

        public static void GLClearError()
        {
            while (GL.glGetError() != GL.GL_NO_ERROR) { }
        }

        public static bool GLLogCall(String file = Compiler.CallerFilePath, String member = Compiler.CallerMemberName, int line = Compiler.CallerLineNum)
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