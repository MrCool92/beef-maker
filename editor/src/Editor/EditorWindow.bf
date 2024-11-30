using ImGui;
using System;

namespace BeefMakerEditor
{
    public class EditorWindow
    {
        protected String name ~ delete _;

        protected virtual void OnUpdate()
        {
        }

        protected virtual void OnGUI()
        {
        }

        private void GUI()
        {
            ImGui.PushStyleVar(.WindowPadding, .(2f, 2f));
            ImGui.Begin(name);
            {
                OnGUI();
            }
            ImGui.End();
            ImGui.PopStyleVar();
        }
    }
}