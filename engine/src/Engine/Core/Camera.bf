namespace BeefMakerEngine
{
    public class Camera
    {
        public Vector3 position;
        public Vector3 target;
        public Vector3 up;

        public float fov;
        public float aspectRatio;
        public float nearClip;
        public float farClip;

        public this(Vector3 position, Vector3 target, Vector3 up)
        {
            this.position = position;
            this.target = target;
            this.up = up;

            fov = 60f;
            aspectRatio = 16f / 9f;
            nearClip = 0.3f;
            farClip = 1000f;
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