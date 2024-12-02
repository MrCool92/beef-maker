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

        private static uint32 dockspaceId;

        public override void OnEnable()
        {
            ImGuiTheme.Init();

            camera = new Camera(Vector3.zero, .(0, 0, 1), Vector3.up);

            Editor.Create<Hierarchy>();
            Editor.Create<Inspector>();
            Editor.Create<BeefMakerEditor.Console>();

            var gameView = Editor.Create<GameView>();
            gameView.camera = camera;
        }

        public override void OnDisable()
        {
            Editor.Disable();
        }

        public override void OnFixedUpdate()
        {
        }

        public override void OnUpdate()
        {
            Editor.Update();
        }

        public override void OnRender()
        {
            Editor.Render();
        }

        public override void OnImGUI()
        {
            Clear();

            DockSpace();

            if (showDemoWindow)
                ImGui.ShowDemoWindow(&showDemoWindow);

            Editor.ImGui();
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
            {
                ImGui.PopStyleVar(4);

                dockspaceId = ImGui.GetID("DockSpace");
                ImGui.DockSpace(dockspaceId, .(0f, 0f), .None);
                MenuBar();

                static bool firstTime = true;
                if (firstTime)
                {
                    firstTime = false;

                    var size = ImGui.GetWindowSize();

                    // Split the dockspace into regions
                    ImGui.ID rightDockId = ImGui.DockBuilderSplitNode(dockspaceId, ImGui.Dir.Right, 0.5f, ?, out dockspaceId);
                    ImGui.ID bottomLeftDockId = ImGui.DockBuilderSplitNode(dockspaceId, ImGui.Dir.Down, 0.35f, ?, out dockspaceId);
                    ImGui.ID leftDockId = ImGui.DockBuilderSplitNode(dockspaceId, ImGui.Dir.Left, 0.5f, ?, out dockspaceId);

                    // Dock windows to specific regions
                    ImGui.DockBuilderDockWindow("Scene Hierarchy", leftDockId);
                    ImGui.DockBuilderDockWindow("Inspector", rightDockId);
                    ImGui.DockBuilderDockWindow("Dear ImGui Demo", rightDockId);
                    ImGui.DockBuilderDockWindow("Game View", dockspaceId);
                    ImGui.DockBuilderDockWindow("Console", bottomLeftDockId);

                    ImGui.DockBuilderSetNodeSize(leftDockId, .(size.x * 0.2f, size.y));
                    ImGui.DockBuilderSetNodeSize(rightDockId, .(size.x * 0.2f, size.y));

                    // Finalize the dock layout
                    ImGui.DockBuilderFinish(dockspaceId);
                }
            }
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
                System.Console.WriteLine($"[OpenGL_Error] {error} in {file} at {member}:{line}");
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