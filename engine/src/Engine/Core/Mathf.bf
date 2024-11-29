namespace BeefMakerEngine
{
    public class Mathf
    {
        public static readonly double pi = 3.141592653589793;

        public static readonly float degToRad = 0.017453292f;

        public static readonly float radToDeg = 57.29578f;

        public static float Radians(float degrees)
        {
            return degrees * degToRad;
        }

        public static float Degrees(float radians)
        {
            return radians * radToDeg;
        }
    }
}