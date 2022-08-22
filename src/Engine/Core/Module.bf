namespace BeefMaker
{
	public abstract class Module
	{
		public virtual void OnEnable() {}
		public virtual void OnDisable() {}
		public virtual void OnFixedUpdate() {}
		public virtual void OnUpdate() {}
		public virtual void OnGUI() {}
	}
}