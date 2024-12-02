using System;
using System.Collections;
using ImGui;

namespace BeefMakerEngine
{
    public class Transform : Component, IEnumerable<Transform>
    {
        public Transform parent { get; private set; }

        public Vector3 localPosition = Vector3.zero;
        public Vector3 localEulerAngles = Vector3.zero;
        public Vector3 localScale = Vector3.one;

        /*public Vector3 position
        {
            get => localToWorld.GetTranslation();
            set mut
            {
                
            }
        }*/

        public Quaternion localRotation
        {
            get => Quaternion.EulerAngels(localEulerAngles);
            set => localToParent.SetRotation(value);
        }

        /*public Quaternion rotation
        {
            get => localToWorld.GetRotation();
            set mut
            {
                
            }
        }*/

        /*public Vector3 eulerAngles
        {
            get => rotation.eulerAngles;
            set mut
            {

            }
        }*/

        private List<Transform> children = new .() ~ delete _;

        public int ChildCount => children.Count;

        public Matrix4x4 localToParent => Matrix4x4.TRS(localPosition, localRotation, localScale);
        public Matrix4x4 localToWorld = Matrix4x4.identity;

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

        public List<Transform>.Enumerator GetEnumerator()
        {
            return children.GetEnumerator();
        }

        /*public struct Enumerator : IEnumerator<Transform>, IResettable
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
                return ++index < parent.ChildCount;
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

        public Enumerator GetEnumerator()
        {
            return Enumerator(this);
        }*/


    }
}