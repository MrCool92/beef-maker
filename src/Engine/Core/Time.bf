using System;
using System.Diagnostics;

namespace BeefMaker
{
	public class Time
	{
		public static readonly double epsilon => 0.001;

		private static double _fixedTimestep = 0.02;
		public static double fixedTimestep
		{
			[Inline] get => _fixedTimestep;
			[Inline] set => _fixedTimestep = Math.[Inline]Max(0.01, value);
		}

		private static double _unscaledTime;
		[Inline] public static double unscaledTime => _unscaledTime;

		private static double _time;
		[Inline] public static double time => _time;

		private static double _deltaTime;
		public static double deltaTime => _deltaTime;

		private static double _timeScale = 1.0;
 		public static double timeScale
		{
			[Inline] get => _timeScale;
			[Inline] set => _timeScale = Math.[Inline]Max(0.01, value);
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
			lastUnscaledTime = _unscaledTime;
			lastTime = _time;
			_unscaledTime = stopwatch.ElapsedMilliseconds / 1000.0;
			_deltaTime = (_unscaledTime - lastUnscaledTime) / _timeScale;
			_time += _deltaTime;
		}
	}
}