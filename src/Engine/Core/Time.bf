using System;
using System.Diagnostics;

namespace BeefMaker
{
	public class Time
	{
		public static readonly double epsilon => 0.001;

		private static double fixedTimestep = 0.02;
		public static double FixedTimestep
		{
			[Inline] get => fixedTimestep;
			[Inline] set => fixedTimestep = Math.[Inline]Max(0.01, value);
		}

		private static double unscaledTime;
		public static double UnscaledTime => unscaledTime;

		private static double time;
		public static double Time => time;

		private static double deltaTime;
		public static double DeltaTime => deltaTime;

		private static double timeScale = 1.0;
 		public static double TimeScale
		{
			[Inline] get => timeScale;
			[Inline] set => timeScale = Math.[Inline]Max(0.01, value);
		}

		private static double lastUnscaledTime;
		private static double lastTime;

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
			unscaledTime = stopwatch.ElapsedMilliseconds / 1000.0;
			deltaTime = (unscaledTime - lastUnscaledTime) / timeScale;
			time += deltaTime;
		}
	}
}