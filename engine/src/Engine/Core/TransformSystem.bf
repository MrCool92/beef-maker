namespace BeefMakerEngine
{
    public static class TransformSystem
    {
        public static void Update()
        {
            var scene = SceneManager.activeScene;
            for (var gameObject in scene)
            {
                UpdateTransformMatrix(gameObject.transform, Matrix4x4.identity);
            }
        }

        private static void UpdateTransformMatrix(Transform transform, Matrix4x4 parentMatrix)
        {
            transform.localToWorld = Mathf.Mul(transform.localToParent, parentMatrix);

            for (var child in transform)
            {
                UpdateTransformMatrix(child, transform.localToWorld);
            }
        }
    }
}
