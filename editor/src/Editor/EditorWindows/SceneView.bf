using BeefMakerEngine;
using ImGui;
using System;

namespace BeefMakerEditor
{
    public class SceneView : Editor
    {
        private RenderTexture renderTexture ~ delete _;

        private Vector2 lastWindowSize;
        private Vector2 windowSize;

        public Camera camera;

        public override void OnEnable()
        {
            name = "Scene View";

            renderTexture = new RenderTexture(640, 480);
        }

        public override void OnRender()
        {
            /*if (renderTexture == null || (lastWindowSize.x != windowSize.x || lastWindowSize.y != windowSize.y))
            {
                lastWindowSize = windowSize;
                camera.aspectRatio = lastWindowSize.x / lastWindowSize.y;
                delete renderTexture;
                renderTexture = new RenderTexture((int)lastWindowSize.x, (int)lastWindowSize.y);
            }*/

            renderTexture.Bind();
            RenderView();
            renderTexture.Unbind();
        }

        public virtual void RenderView()
        {
        }

        public override void OnImGUI()
        {
            if (renderTexture.Ready)
            {
                ImGui.BeginChild("Render");

                windowSize = ImGui.GetWindowSize();
                ImGui.Image(renderTexture.TextureId, windowSize, .(0, 1), .(1, 0));

                ImGui.EndChild();
            }
        }
    }
}