namespace BeefMakerEngine
{
    public class Box
    {
        public GameObject gameObject { get; private set; } ~ delete _;

        private Mesh mesh ~ delete _;
        private Material material ~ delete _;

        private MeshRenderer meshRenderer;

        public Vector3 position
        {
            get => meshRenderer.worldMatrix.GetTranslation();
            set => meshRenderer.worldMatrix.SetTranslation(value);
        }

        public this()
        {
            gameObject = GameObject.Insantiate("Box");
            gameObject.transform.localPosition = .(0, 0, 10);

            var child = GameObject.Insantiate("Child");
            child.transform.SetParent(gameObject.transform);

            float[] vertices = new .( //
                // Front face
                -0.5f, -0.5f,  0.5f, // Bottom-left
                0.5f, -0.5f,  0.5f, // Bottom-right
                0.5f,  0.5f,  0.5f, // Top-right
                -0.5f,  0.5f,  0.5f, // Top-left

                // Back face
                -0.5f, -0.5f, -0.5f, // Bottom-left
                0.5f, -0.5f, -0.5f, // Bottom-right
                0.5f,  0.5f, -0.5f, // Top-right
                -0.5f,  0.5f, -0.5f // Top-left
                );

            uint32[] indices = new .( //
                // Front face
                0, 1, 2, // First triangle
                2, 3, 0, // Second triangle

                // Back face
                4, 5, 6, // First triangle
                6, 7, 4, // Second triangle

                // Left face
                4, 0, 3, // First triangle
                3, 7, 4, // Second triangle

                // Right face
                1, 5, 6, // First triangle
                6, 2, 1, // Second triangle

                // Top face
                3, 2, 6, // First triangle
                6, 7, 3, // Second triangle

                // Bottom face
                4, 5, 1, // First triangle
                1, 0, 4 // Second triangle
                );

            mesh = new Mesh(vertices, indices);

            var shader = new Shader("../data/shaders/default.shader");
            material = new Material(shader);

            meshRenderer = gameObject.AddComponent<MeshRenderer>();
            meshRenderer.mesh = mesh;
            meshRenderer.material = material;
        }

        public void Render(Camera camera)
        {
            meshRenderer.Render(camera);
        }

        public void Move(Vector3 direction)
        {
            position += direction * (5f * Time.DeltaTime);
        }
    }
}