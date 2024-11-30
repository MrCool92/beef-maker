using System;
using System.Collections;

namespace BeefMakerEngine
{
    public class Scene : IEnumerable<GameObject>
    {
        private List<GameObject> rootObjects = new .() ~ delete _;

        public void MoveGameObject(GameObject gameObject)
        {
            gameObject.[Friend]scene = this;
            gameObject.transform.SetParent(null);
            rootObjects.Add(gameObject);
        }

        public struct Enumerator : IRefEnumerator<GameObject*>, IEnumerator<GameObject>, IResettable
        {
            private List<GameObject> objects;

            private int index = -1;

            public GameObject Current => objects[index];

            public ref GameObject CurrentRef => ref objects[index];

            public this(List<GameObject> objects)
            {
                this.objects = objects;
            }

            public Result<GameObject> GetNext() mut
            {
                if (!MoveNext())
                    return .Err;
                return Current;
            }

            public Result<GameObject*> GetNextRef() mut
            {
                if (!MoveNext())
                    return .Err;
                return &CurrentRef;
            }

            public void Reset() mut
            {
                index = -1;
            }

            private bool MoveNext() mut
            {
                return ++index < objects.Count;
            }
        }

        public IEnumerator<GameObject> GetEnumerator()
        {
            return new box Enumerator(rootObjects);
        }
    }
}