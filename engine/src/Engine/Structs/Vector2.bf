using System;

namespace BeefMakerEngine
{
    public struct Vector2
    {
        public readonly static Vector2 zero  = .(0f,  0f);
        public readonly static Vector2 one   = .(1f,  1f);
        public readonly static Vector3 up    = .(0f,  1f);
        public readonly static Vector3 down  = .(0f, -1f);
        public readonly static Vector3 left  = .(-1f, 0f);
        public readonly static Vector3 right = .(1f,  0f);

        public float x;
        public float y;

        public this(float x, float y)
        {
            this.x = x;
            this.y = y;
        }

        public void Normalize() mut
        {
            float num = Vector2.Magnitude(this);
            if ((double)num > 9.99999974737875E-06)
                this = this / num;
            else
                this = zero;
        }

        public Vector2 normalized
        {
            get
            {
                float num = Vector2.Magnitude(this);
                if ((double)num > 9.99999974737875E-06)
                    return this / num;
                else
                    return zero;
            }
        }

        public static float Dot(Vector2 a, Vector2 b)
        {
            return a.x * b.x + a.y * b.y;
        }

        public static float Magnitude(Vector2 vector)
        {
            return (float)Math.Sqrt((double)vector.x * (double)vector.x + (double)vector.y * (double)vector.y);
        }

        public static Vector2 operator +(Vector2 a, Vector2 b) => .(a.x + b.x, a.y + b.y);

        public static Vector2 operator -(Vector2 a, Vector2 b) => .(a.x - b.x, a.y - b.y);

        public static Vector2 operator -(Vector2 a) => .(-a.x, -a.y);

        public static Vector2 operator *(Vector2 a, float b) => .(a.x * b, a.y * b);

        public static Vector2 operator *(float a, Vector2 b) => .(b.x * a, b.y * a);

        public static Vector2 operator /(Vector2 a, float b) => .(a.x / b, a.y / b);

        public static bool operator ==(Vector2 a, Vector2 b)
        {
            float abx = a.x - b.x;
            float aby = a.y - b.y;
            return (double)abx * (double)abx + (double)aby * (double)aby < 9.99999943962493E-11;
        }

        public static bool operator !=(Vector2 a, Vector2 b) => !(a == b);

        public static operator float*(ref Vector2 a) => &a.x;

        public static operator Vector2(ref ImGui.ImGui.Vec2 a) => .(a.x, a.y);
        public static operator ImGui.ImGui.Vec2(ref Vector2 a) => .(a.x, a.y);
    }
}