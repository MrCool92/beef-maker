namespace BeefMakerEngine
{
    public class Camera
    {
        public Vector3 position;
        public Vector3 target;
        public Vector3 up;

        public float fov = 60f;
        public float aspectRatio = 16f / 9f;
        public float nearClip = 0.3f;
        public float farClip = 1000f;

        private RenderTexture renderTexture ~ delete _;

        public this(Vector3 position, Vector3 target, Vector3 up)
        {
            this.position = position;
            this.target = target;
            this.up = up;
        }

        public Matrix4x4 GetViewMatrix()
        {
            return Matrix4x4.LookAt(position, target, up);
        }

        public Matrix4x4 GetProjectionMatrix()
        {
            return Matrix4x4.Perspective(fov * Mathf.degToRad, aspectRatio, nearClip, farClip);
        }

        public void Move(Vector3 direction)
        {
            position += direction * (1f * Time.DeltaTime);
            target = position + .(0, 0, 1);
        }
    }
}