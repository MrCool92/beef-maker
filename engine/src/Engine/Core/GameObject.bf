using System;
using System.Collections;

namespace BeefMakerEngine
{
    public class GameObject : IHashable
    {
        public String name;

        private List<Component> components = new .() ~ delete _;

        public Scene scene { get; private set; }

        public Transform transform { get; private set; }

        public int id { get; private set; }

        private static int nextId;

        public static GameObject Insantiate(String name = "GameObject")
        {
            var gameObject = new GameObject(name);
            SceneManager.activeScene.MoveGameObject(gameObject);
            return gameObject;
        }

        public this(String name)
        {
            this.name = name;
            transform = AddComponent<Transform>();
            id = nextId++;
        }

        public ~this()
        {
            for (var component in components)
                delete component;
        }

        public TComponent AddComponent<TComponent>()
            where TComponent : Component
        {
            var component = new TComponent();
            component.[Friend]gameObject = this;
            components.Add(component);
            return component;
        }

        public TComponent GetComponent<TComponent>()
            where TComponent : Component
        {
            for (var component in components)
            {
                if (component.GetType() == typeof(TComponent))
                    return component;
            }
            return null;
        }

        public int GetHashCode() => id;
    }
}