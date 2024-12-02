using BeefMakerEngine;
using ImGui;
using System;
using System.Collections;

namespace BeefMakerEditor
{
    public static class Selection
    {
        public static List<GameObject> selected = new .() ~ delete _;

        public static Event<delegate void()> OnSelectionChanged = default;
    }

    public class Hierarchy : Editor
    {
        public this()
        {
            name = "Scene Hierarchy";
        }

        public override void OnImGUI()
        {
            static ImGui.TreeNodeFlags treeNodeFlags = .OpenOnArrow | .SpanFullWidth;

            var scene = SceneManager.activeScene;

            for (var gameObject in scene)
                DrawNode(gameObject, treeNodeFlags);
        }

        private void DrawNode(GameObject gameObject, ImGui.TreeNodeFlags treeNodeFlags)
        {
            System.Diagnostics.Debug.Assert(gameObject != null, "gameObject is null!");

            var name = scope String(256);
            gameObject.GetName(name);
            System.Diagnostics.Debug.Assert(!String.IsNullOrEmpty(name), "gameObject.name is null or empty!");

            var nodeFlags = treeNodeFlags;

            if (Selection.selected.Contains(gameObject))
                nodeFlags |= .Selected;

            ImGui.PushID(scope String(gameObject.GetHashCode()));
            bool opened = ImGui.TreeNodeEx("GameObject", nodeFlags, name);

            if (ImGui.IsItemClicked())
            {
                if (!ImGui.GetKeyData(.ModShift).Down)
                    Selection.selected.Clear();

                Selection.selected.Add(gameObject);

                Selection.OnSelectionChanged();
            }

            if (opened)
            {
                for (var child in gameObject.transform.[Friend]children)
                    DrawNode(child.gameObject, treeNodeFlags);

                ImGui.TreePop();
            }
            ImGui.PopID();
        }
    }
}