namespace BeefMakerEngine
{
    public class Box
    {
        public GameObject gameObject { get; private set; } ~ delete _;

        private Mesh mesh ~ delete _;
        private Material cubeMaterial ~ delete _;
        private Material childMaterial ~ delete _;

        private MeshRenderer cubeMeshRenderer;
        private MeshRenderer childMeshRenderer;

        public this()
        {
            gameObject = GameObject.Instantiate("Box");
            gameObject.transform.localPosition = .(0, 0, 10);

            var shader = new Shader("../data/shaders/default.shader");

            cubeMaterial = new Material(shader);
            cubeMeshRenderer = gameObject.AddComponent<MeshRenderer>();
            cubeMeshRenderer.mesh = PrimitiveObject.Cube.GetShared();
            cubeMeshRenderer.material = cubeMaterial;
            cubeMeshRenderer.color = .(1, 0, 0, 1);

            var child = GameObject.Instantiate("Sphere");
            child.transform.SetParent(gameObject.transform);
            child.transform.localPosition = .(2, 0, 0);

            childMaterial = new Material(shader);
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