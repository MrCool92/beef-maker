using System;
using System.Collections;

namespace BeefMakerEngine
{
    public class GameObject : IHashable
    {
        private String name = new String(256) ~ delete _;

        private List<Component> components = new .() ~ delete _;

        public Scene scene { get; private set; }

        public Transform transform { get; private set; }

        public int id { get; private set; }

        private static int nextId;

        public this(StringView name)
        {
            SetName(name);
            transform = AddComponent<Transform>();
            id = nextId++;
        }

        public ~this()
        {
            for (var c in components)
                delete c;
        }

        public void GetName(String strBuffer)
        {
            strBuffer.Append(name);
        }

        public void SetName(StringView newName)
        {
            name.Set(newName);
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

        public static GameObject Instantiate(StringView name = "GameObject", Scene scene = null)
        {
            var gameObject = new GameObject(name);
            if (scene == null)
            {
                SceneManager.activeScene.MoveGameObject(gameObject);
            }
            else
            {
                scene.MoveGameObject(gameObject);
            }
            return gameObject;
        }
    }
}