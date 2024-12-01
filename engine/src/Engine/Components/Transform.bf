using System;
using System.Collections;
using ImGui;

namespace BeefMakerEngine
{
    public class Transform : Component, IEnumerable<Transform>
    {
        public Transform parent { get; private set; }

        public Vector3 localPosition;

        public Vector3 position
        {
            get => localToWorld.GetTranslation();
            set
            {
                localToWorld.SetTranslation(value);
                localToParent.SetTranslation(Vector3.zero);
            }
        }

        public Quaternion localRotation
        {
            get => Quaternion.EulerAngels(localEulerAngles);
            set => localToParent.SetRotation(value);
        }

        public Quaternion rotation
        {
            get => localToWorld.GetRotation();
            set
            {
                localToWorld.SetRotation(value);
                localToParent.SetRotation(Quaternion.identity);
            }
        }

        public Vector3 localScale = Vector3.one;

        public Vector3 localEulerAngles;

        /*public Vector3 eulerAngles
        {
            get => rotation.eulerAngles;
            set => rotation = Quaternion.EulerAngels(value);
        }*/

        private List<Transform> children = new .() ~ delete _;

        public int childCount => children.Count;

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

        public override void OnImGui()
        {
            // Position
            ImGui.PushID("Position");
            float[3] localPosition = this.localPosition;
            if (GUI.Vector3Field("Position", localPosition, "%.2f"))
            {
                this.localPosition = localPosition;
            }
            ImGui.PopID();

            // Rotation
            ImGui.PushID("Rotation");
            float[3] localEulerAngles = this.localEulerAngles;
            if (GUI.Vector3Field("Rotation", localEulerAngles, "%.2f"))
            {
                this.localEulerAngles = localEulerAngles;
            }
            ImGui.PopID();

            // Scale
            ImGui.PushID("Scale");
            float[3] localScale = this.localScale;
            if (GUI.Vector3Field("Scale", localScale, "%.2f"))
            {
                this.localScale = localScale;
            }
            ImGui.PopID();
        }
    }
}