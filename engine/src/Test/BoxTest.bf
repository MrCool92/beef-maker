namespace BeefMakerEngine
{
    public class Box
    {
        public GameObject gameObject { get; private set; }

        private Mesh mesh ~ delete _;
        private Material cubeMaterial ~ delete _;
        private Material childMaterial ~ delete _;

        private MeshRenderer cubeMeshRenderer;
        private MeshRenderer childMeshRenderer;

        private Shader defaultShader ~ delete _;

        public this()
        {
            gameObject = GameObject.Instantiate("Box");
            gameObject.transform.localPosition = .(0, 0, 10);

            defaultShader = new Shader("../data/shaders/default.shader");

            cubeMaterial = new Material(defaultShader);
            cubeMeshRenderer = gameObject.AddComponent<MeshRenderer>();
            cubeMeshRenderer.mesh = PrimitiveObject.Cube.GetShared();
            cubeMeshRenderer.material = cubeMaterial;
            cubeMeshRenderer.color = .(1, 0, 0, 1);

            var child = GameObject.Instantiate("Sphere");
            child.transform.SetParent(gameObject.transform);
            child.transform.localPosition = .(2, 0, 0);

            childMaterial = new Material(defaultShader);
            childMeshRenderer = child.AddComponent<MeshRenderer>();
            childMeshRenderer.mesh = PrimitiveObject.Sphere.GetShared();
            childMeshRenderer.material = childMaterial;
            childMeshRenderer.color = .(0, 0, 1, 1);
        }

        public void Render(Camera camera)
        {
            cubeMeshRenderer.Render(camera);
            childMeshRenderer.Render(camera);
        }

        public void Move(Vector3 direction)
        {
            gameObject.transform.localPosition += direction * (5f * Time.DeltaTime);
        }
    }
}