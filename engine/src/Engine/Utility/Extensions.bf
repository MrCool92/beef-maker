using BeefMakerEngine;

namespace ImGui
{
    extension ImGui
    {
        extension Vec2
        {
            public static operator Vector2(Vec2 a) => .(a.x, a.y);
            public static operator Vec2(ref Vector2 a) => .(a.x, a.y);
        }
    }
}