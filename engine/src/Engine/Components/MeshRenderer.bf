using ImGui;

namespace BeefMakerEngine
{
    public class MeshRenderer : Component
    {
        public Mesh mesh;
        public Material material;

        public Color color;

        public void Render(Camera camera)
        {
            // Use the shader program
            material.shader.Bind();

            // Set the model, view, and projection matrices
            material.SetMatrix4x4("model", gameObject.transform.localToWorld);
            material.SetMatrix4x4("view", camera.GetViewMatrix());
            material.SetMatrix4x4("projection", camera.GetProjectionMatrix());
            material.SetColor4("tint", color);

            mesh.Render();

            material.shader.Unbind();
        }

        public override void OnImGui()
        {
            // Color
            ImGui.PushID("Color");
            float[4] color = this.color;
            if (ImGui.ColorEdit4("Color", color))
            {
                this.color = color;
            }
            ImGui.PopID();
        }
    }
}