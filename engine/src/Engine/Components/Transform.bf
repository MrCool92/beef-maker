using System;
using System.Collections;

namespace BeefMakerEngine
{
    public class Transform : Component, IEnumerable<Transform>
    {
        public Transform parent { get; private set; }

        public Vector3 localPosition;

        private List<Transform> children = new .() ~ delete _;

        public int childCount => children.Count;

        public void SetParent(Transform parent)
        {
            if (parent != null)
                parent.children.Remove(this);

            this.parent = parent;

            if (parent != null)
            {
                parent.children.Add(this);
                gameObject.scene.[Friend]rootObjects.Remove(this.gameObject);
            }
        }

        public Transform GetChild(int index)
        {
            return children[index];
        }

        public struct Enumerator : IEnumerator<Transform>, IResettable
        {
            private Transform parent;

            private int index = -1;

            public this(Transform parent)
            {
                this.parent = parent;
            }

            public Transform Current => parent.GetChild(index);

            public bool MoveNext() mut
            {
                return ++index < parent.childCount;
            }

            public void Reset() mut
            {
                index = -1;
            }

            public Result<Transform> GetNext() mut
            {
                if (!MoveNext())
                    return .Err;
                return Current;
            }
        }

        public IEnumerator<Transform> GetEnumerator()
        {
            return new box Enumerator(this);
        }
    }
}