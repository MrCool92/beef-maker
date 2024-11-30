using BeefMakerEngine;
using ImGui;
using System;

namespace BeefMakerEditor
{
    public class SceneView : EditorWindow
    {
        private RenderTexture renderTexture ~ delete _;

        private Vector2 lastWindowSize;
        private Vector2 windowSize;

        public Event<delegate void()> OnGameWindowSizeChanged;

        public Camera camera;

        public this()
        {
            name = "SceneView";
        }

        private void Update()
        {
            if (renderTexture == null || (lastWindowSize.x != windowSize.x || lastWindowSize.y != windowSize.y))
            {
                lastWindowSize = windowSize;
                camera.aspectRatio = lastWindowSize.x / lastWindowSize.y;
                delete renderTexture;
                renderTexture = new RenderTexture((int)lastWindowSize.x, (int)lastWindowSize.y);
            }
            OnUpdate();
        }

        private void Render()
        {
            renderTexture.Bind();
            OnRender();
            renderTexture.Unbind();
        }

        protected virtual void OnRender()
        {
        }

        protected override void OnGUI()
        {
            ImGui.BeginChild("Render");
            {
                windowSize = ImGui.GetWindowSize();
                ImGui.Image(renderTexture.TextureId, windowSize, ImGui.Vec2(0, 1), ImGui.Vec2(1, 0));
            }
            ImGui.EndChild();
        }
    }
}