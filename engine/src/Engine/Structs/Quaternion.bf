using System;

namespace BeefMakerEngine
{
    [UnderlyingArray(typeof(float), 4, true)]
    public struct Quaternion
    {
        public static readonly Quaternion identity = .(0f, 0f, 0f, 1f);

        public float x;
        public float y;
        public float z;
        public float w;

        public this(float x, float y, float z, float w)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }

        public static Quaternion FromMatrix(Matrix4x4 matrix)
        {
            float trace = matrix.m00 + matrix.m11 + matrix.m22;
            Quaternion q = default;
            if ((double)trace > 0.0)
            {
                float s = (float)Math.Sqrt((double)trace + 1.0);
                q.w = s * 0.5f;
                float inverse = 0.5f / s;
                q.x = (matrix.m21 - matrix.m12) * inverse;
                q.y = (matrix.m02 - matrix.m20) * inverse;
                q.z = (matrix.m10 - matrix.m01) * inverse;
            }
            else if ((double)matrix.m00 >= (double)matrix.m11 && (double)matrix.m00 >= (double)matrix.m22)
            {
                float s = (float)Math.Sqrt(1.0 + (double)matrix.m00 - (double)matrix.m11 - (double)matrix.m22);
                float inverse = 0.5f / s;
                q.x = 0.5f * s;
                q.y = (matrix.m01 + matrix.m10) * inverse;
                q.z = (matrix.m02 + matrix.m20) * inverse;
                q.w = (matrix.m21 - matrix.m12) * inverse;
            }
            else if ((double)matrix.m11 > (double)matrix.m22)
            {
                float s = (float)Math.Sqrt(1.0 + (double)matrix.m11 - (double)matrix.m00 - (double)matrix.m22);
                float inverse = 0.5f / s;
                q.x = (matrix.m10 + matrix.m01) * inverse;
                q.y = 0.5f * s;
                q.z = (matrix.m21 + matrix.m12) * inverse;
                q.w = (matrix.m02 - matrix.m20) * inverse;
            }
            else
            {
                float s = (float)Math.Sqrt(1.0 + (double)matrix.m22 - (double)matrix.m00 - (double)matrix.m11);
                float inverse = 0.5f / s;
                q.x = (matrix.m20 + matrix.m02) * inverse;
                q.y = (matrix.m21 + matrix.m12) * inverse;
                q.z = 0.5f * s;
                q.w = (matrix.m10 - matrix.m01) * inverse;
            }
            return q;
        }

        public Matrix4x4 ToMatrix4x4()
        {
            float x = this.x * 2f;
            float y = this.y * 2f;
            float z = this.z * 2f;
            float xx = this.x * x;
            float yy = this.y * y;
            float zz = this.z * z;
            float xy = this.x * y;
            float xz = this.x * z;
            float yz = this.y * z;
            float wx = this.w * x;
            float wy = this.w * y;
            float wz = this.w * z;

            return .(
                1f - (yy + zz),
                xy + wz,
                xz - wy,
                0f,
                xy - wz,
                1f - (xx + zz),
                yz + wx,
                0f,
                xz + wy,
                yz - wx,
                1f - (xx + yy),
                0f,
                0f,
                0f,
                0f,
                1f
                );
        }

        public float yaw => (float)Math.Asin(-2.0 * (x * z - w * y));

        public float pitch => (float)Math.Atan2(2.0 * (y * z + w * x), (w * w - x * x - y * y + z * z));

        public float roll => (float)Math.Atan2(2.0 * (x * y + w * z), (w * w + x * x - y * y - z * z));

        public Vector3 eulerAngles => .(pitch * Mathf.radToDeg, yaw * Mathf.radToDeg, roll * Mathf.radToDeg);

        public static Quaternion EulerAngels(Vector3 eulerAngles)
        {
            float halfPitch = eulerAngles.x * Mathf.degToRad / 2f;
            float halfYaw = eulerAngles.y * Mathf.degToRad / 2f;
            float halfRoll = eulerAngles.z * Mathf.degToRad / 2f;

            float sinPitch = Math.Sin(halfPitch);
            float cosPitch = Math.Cos(halfPitch);

            float sinYaw = Math.Sin(halfYaw);
            float cosYaw = Math.Cos(halfYaw);

            float sinRoll = Math.Sin(halfRoll);
            float cosRoll = Math.Cos(halfRoll);

            return .(
                cosYaw * sinPitch * cosRoll - sinYaw * cosPitch * sinRoll,
                sinYaw * cosPitch * cosRoll + cosYaw * sinPitch * sinRoll,
                cosYaw * cosPitch * sinRoll + sinYaw * sinPitch * cosRoll,
                cosYaw * cosPitch * cosRoll - sinYaw * sinPitch * sinRoll
                );
        }
    }
}