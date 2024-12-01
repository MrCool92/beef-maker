namespace BeefMakerEngine
{
    public abstract class Component
    {
        public GameObject gameObject { get; private set; }

        public virtual void OnImGui()
        {
        }
    }
}