namespace BeefMakerEngine
{
    public class MeshRenderer
    {
        public Matrix4x4 worldMatrix = Matrix4x4.identity;

        public Mesh mesh;
        public Material material;

        public this()
        {
        }

        public void Render(Camera camera)
        {
            // Use the shader program
            material.shader.Bind();

            // Set the model, view, and projection matrices
            material.SetMatrix4x4("model", worldMatrix);
            material.SetMatrix4x4("view", camera.GetViewMatrix());
            material.SetMatrix4x4("projection", camera.GetProjectionMatrix());
            material.SetColor4("tint", .(1, 0, 0, 1));

            mesh.Render();

            material.shader.Unbind();
        }
    }
}