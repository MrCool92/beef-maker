using BeefMakerEngine;
using ImGui;
using System;

namespace BeefMakerEditor
{
    public class Inspector : Editor
    {
        private const int bufferSize = 256;
        private char8* buffer = (char8*)Internal.Malloc(bufferSize) ~ delete _;
        private delegate void() onSelectionChanged ~ delete _;

        public override void OnEnable()
        {
            name = "Inspector";
            onSelectionChanged = new => OnSelectionChanged;
            Selection.OnSelectionChanged.Add(onSelectionChanged);
        }

        public override void OnDisable()
        {
            Selection.OnSelectionChanged.Remove(onSelectionChanged);
        }

        public override void OnImGUI()
        {
            if (Selection.selected.Count == 0)
                return;

            var selected = Selection.selected[0];

            if (ImGui.InputText("Name", buffer, bufferSize))
            {
                selected.SetName(StringView(buffer, String.StrLen(buffer)));
            }

            int i = 0;
            for (var component in selected.[Friend]components)
            {
                var name = scope String();
                component.GetType().GetName(name);
                ImGui.PushID(scope String()..AppendF("{}_{}", selected.GetHashCode(), i++));
                //ImGui.PushItemWidth(width /*ImGui.GetFontSize() * -7*/);
                if (ImGui.CollapsingHeader(name, .DefaultOpen))
                {
                    ImGui.Indent();
                    component.OnImGui();
                    ImGui.Unindent();

                    ImGui.SeparatorEx(.Horizontal);
                }
                ImGui.PopID();
                //ImGui.PopItemWidth();
            }
        }

        private void OnSelectionChanged()
        {
            if (Selection.selected.Count == 0)
                return;

            var name = Selection.selected[0].[Friend]name;
            Internal.MemCpy(buffer, name.Ptr, name.Length);
            buffer[name.Length] = 0;
        }
    }
}