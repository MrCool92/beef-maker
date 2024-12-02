using ImGui;

namespace BeefMakerEngine
{
    extension MeshRenderer
    {
        public override void OnImGui()
        {
            ImGui.PushID("Color");
            float[4] color = this.color;
            if (ImGui.ColorEdit4("Color", color))
            {
                this.color = color;
            }
            ImGui.PopID();
        }
    }
}
