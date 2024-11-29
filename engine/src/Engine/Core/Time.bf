using System;
using System.Diagnostics;

namespace BeefMakerEngine
{
    public class Time
    {
        public static readonly float epsilon => 0.001f;

        private static float fixedTimestep = 0.02f;
        public static float FixedTimestep
        {
            [Inline] get => fixedTimestep;
            [Inline] set => fixedTimestep = Math.[Inline]Max(0.01f, value);
        }

        private static float unscaledTime;
        public static float UnscaledTime => unscaledTime;

        private static float time;
        public static float Time => time;

        private static float deltaTime;
        public static float DeltaTime => deltaTime;

        private static float timeScale = 1.0f;
        public static float TimeScale
        {
            [Inline] get => timeScale;
            [Inline] set => timeScale = Math.[Inline]Max(0.01f, value);
        }

        private static float lastUnscaledTime;
        private static float lastTime;

        private Stopwatch stopwatch ~ delete _;

        public this()
        {
            stopwatch = new Stopwatch(true);
            stopwatch.Start();
        }

        public void Update()
        {
            lastUnscaledTime = unscaledTime;
            lastTime = time;
            unscaledTime = stopwatch.ElapsedMilliseconds / 1000f;
            deltaTime = (unscaledTime - lastUnscaledTime) / timeScale;
            time += deltaTime;
        }
    }
}