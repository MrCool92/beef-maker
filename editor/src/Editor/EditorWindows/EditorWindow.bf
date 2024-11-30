using ImGui;
using System;

namespace BeefMakerEditor
{
    public abstract class EditorWindow
    {
        protected String name;

        protected virtual void OnUpdate()
        {
        }

        protected virtual void OnImGUI()
        {
        }

        private void ImGUIInternal()
        {
            ImGui.PushStyleVar(.WindowPadding, .(2f, 2f));
            ImGui.Begin(name);
            {
                OnImGUI();
            }
            ImGui.End();
            ImGui.PopStyleVar();
        }
    }
}