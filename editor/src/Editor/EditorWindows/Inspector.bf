using BeefMakerEngine;
using ImGui;
using System;

namespace BeefMakerEditor
{
    public class Inspector : EditorWindow
    {
        public this()
        {
            name = "Inspector";
        }

        protected override void OnImGUI()
        {
            if (Selection.selected.Count == 0)
                return;

            var selected = Selection.selected[0];

            ImGui.PushItemWidth(ImGui.GetFontSize() * -7);

            int i = 0;
            for (var component in selected.[Friend]components)
            {
                var name = scope String();
                component.GetType().GetName(name);
                ImGui.PushID(scope String()..AppendF("{}_{}", selected.GetHashCode(), i++));
                if (ImGui.CollapsingHeader(name, .DefaultOpen))
                {
                    component.OnImGui();
                    ImGui.SeparatorEx(.Horizontal);
                }
                ImGui.PopID();
            }
        }
    }
}