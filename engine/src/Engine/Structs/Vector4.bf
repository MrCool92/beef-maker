using System;

namespace BeefMakerEngine
{
    [UnderlyingArray(typeof(float), 4, true)]
    public struct Vector4
    {
        public readonly static Vector4 zero = .(0f,  0f,  0f, 0f);
        public readonly static Vector4 one  = .(1f,  1f,  1f, 1f);

        public float x;
        public float y;
        public float z;
        public float w;

        [Inline] public this(float x, float y, float z, float w)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }

        [Inline] public this(float x, float y, float z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = 0;
        }

        [Inline] public this(float x, float y)
        {
            this.x = x;
            this.y = y;
            this.z = 0;
            this.w = 0;
        }

        public void Normalize() mut
        {
            float num = Vector4.Magnitude(this);
            if ((double)num > 9.99999974737875E-06)
                this = this / num;
            else
                this = Vector4.zero;
        }

        public static float Magnitude(Vector4 vector)
        {
            return (float)Math.Sqrt((double)vector.x * (double)vector.x + (double)vector.y * (double)vector.y + (double)vector.z * (double)vector.z + (double)vector.w * (double)vector.w);
        }

        public static Vector4 operator +(Vector4 a, Vector4 b) => .(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w);

        public static Vector4 operator -(Vector4 a, Vector4 b) => .(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w);

        public static Vector4 operator -(Vector4 a) => .(-a.x, -a.y, -a.z, -a.w);

        public static Vector4 operator *(Vector4 a, float b) => .(a.x * b, a.y * b, a.z * b, a.w * b);

        public static Vector4 operator *(float a, Vector4 b) => .(b.x * a, b.y * a, b.z * a, b.w * a);

        public static Vector4 operator /(Vector4 a, float b) => .(a.x / b, a.y / b, a.z / b, a.w / b);

        public static bool operator ==(Vector4 a, Vector4 b)
        {
            float abx = a.x - b.x;
            float aby = a.y - b.y;
            float abz = a.z - b.z;
            float abw = a.w - b.w;
            return (double)abx * (double)abx + (double)aby * (double)aby + (double)abz * (double)abz + (double)abw * (double)abw < 9.99999943962493E-11;
        }

        public static bool operator !=(Vector4 a, Vector4 b) => !(a == b);
    }
}