using System;

namespace BeefMakerEngine
{
    public struct Vector3
    {
        public readonly static Vector3 zero 	= .(0f,  0f,  0f);
        public readonly static Vector3 one 		= .(1f,  1f,  1f);
        public readonly static Vector3 up 		= .(0f,  1f,  0f);
        public readonly static Vector3 down 	= .(0f, -1f,  0f);
        public readonly static Vector3 left 	= .(-1f,  0f,  0f);
        public readonly static Vector3 right 	= .(1f,  0f,  0f);
        public readonly static Vector3 forward 	= .(0f,  0f,  1f);
        public readonly static Vector3 back 	= .(0f,  0f, -1f);

        public float x;
        public float y;
        public float z;

        [Inline] public this(float x, float y, float z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        [Inline] public this(float x, float y)
        {
            this.x = x;
            this.y = y;
            this.z = 0f;
        }

        public void Normalize() mut
        {
            float num = Vector3.Magnitude(this);
            if ((double)num > 9.99999974737875E-06)
                this = this / num;
            else
                this = zero;
        }

        public Vector3 normalized
        {
            get
            {
                float num = Vector3.Magnitude(this);
                if ((double)num > 9.99999974737875E-06)
                    return this / num;
                else
                    return zero;
            }
        }

        public static Vector3 Cross(Vector3 a, Vector3 b)
        {
            return .(
                a.y * b.z - a.z * b.y,
                a.z * b.x - a.x * b.z,
                a.x * b.y - a.y * b.x
                );
        }

        public static float Dot(Vector3 a, Vector3 b)
        {
            return a.x * b.x + a.y * b.y + a.z * b.z;
        }

        public static float Magnitude(Vector3 vector)
        {
            return (float)Math.Sqrt((double)vector.x * (double)vector.x + (double)vector.y * (double)vector.y + (double)vector.z * (double)vector.z);
        }

        public static Vector3 operator +(Vector3 a, Vector3 b) => .(a.x + b.x, a.y + b.y, a.z + b.z);

        public static Vector3 operator -(Vector3 a, Vector3 b) => .(a.x - b.x, a.y - b.y, a.z - b.z);

        public static Vector3 operator -(Vector3 a) => .(-a.x, -a.y, -a.z);

        public static Vector3 operator *(Vector3 a, float b) => .(a.x * b, a.y * b, a.z * b);

        public static Vector3 operator *(float a, Vector3 b) => .(b.x * a, b.y * a, b.z * a);

        public static Vector3 operator /(Vector3 a, float b) => .(a.x / b, a.y / b, a.z / b);

        public static bool operator ==(Vector3 a, Vector3 b)
        {
            float abx = a.x - b.x;
            float aby = a.y - b.y;
            float abz = a.z - b.z;
            return (double)abx * (double)abx + (double)aby * (double)aby + (double)abz * (double)abz < 9.99999943962493E-11;
        }

        public static bool operator !=(Vector3 a, Vector3 b) => !(a == b);

        public static implicit operator float[3](Vector3 a)
        {
            return .(a.x, a.y, a.z);
        }

        public static implicit operator Vector3(float[3] a)
        {
            return .(a[0], a[1], a[2]);
        }
    }
}