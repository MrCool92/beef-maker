namespace BeefMakerEngine
{
	public class Utility
	{
		public static mixin FillArrayWithScopedInstances(var array)
		{
		    for (let i < (int)array.Count)
		        array[i] = scope:mixin .();
		    array
		}
	}
}