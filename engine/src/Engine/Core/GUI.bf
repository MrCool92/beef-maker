using System;
using ImGui;

namespace BeefMakerEngine
{
    public static class GUI
    {
        public static bool Vector3Field(char8* label, float[3] v, char8* format = "%.3f", ImGui.SliderFlags flags = (ImGui.SliderFlags)0)
        {
            var window = ImGui.GetCurrentWindow();
            if (window.SkipItems)
                return false;

            var g = ImGui.GetCurrentContext();
            bool valueChanged = false;
            ImGui.BeginGroup();
            ImGui.PushID(label);

            ImGui.PushMultiItemsWidths(3, ImGui.CalcItemWidth());
            ImGui.size type_size = ImGui.DataTypeGetInfo(.Float).Size;
            void* val = &v;
            for (int32 i = 0; i < 3; i++)
            {
                ImGui.PushID(i);
                if (i > 0)
                    ImGui.SameLine(0, g.Style.ItemInnerSpacing.x);

                ImGui.PushStyleColor(.FrameBg, .(i == 0 ? 1f : 0f, i == 1 ? 1f : 0f, i == 2 ? 1f : 0f, 0.4f));
                ImGui.PushStyleColor(.Border, .(i == 0 ? 1f : 0f, i == 1 ? 1f : 0f, i == 2 ? 1f : 0f, 0.8f));
                ImGui.PushStyleColor(.FrameBgActive, .(i == 0 ? 1f : 0f, i == 1 ? 1f : 0f, i == 2 ? 1f : 0f, 0.6f));
                ImGui.PushStyleColor(.FrameBgHovered, .(i == 0 ? 1f : 0f, i == 1 ? 1f : 0f, i == 2 ? 1f : 0f, 0.5f));
                valueChanged |= ImGui.DragScalar("", .Float, val, 0.01f, null, null, format, flags);
                ImGui.PopStyleColor(4);

                ImGui.PopID();
                ImGui.PopItemWidth();
                val = (void*)((char8*)val + sizeof(float));
            }
            ImGui.PopID();

            char8* label_end = ImGui.FindRenderedTextEnd(label);
            if (label != label_end)
            {
                ImGui.SameLine(0.0f, g.Style.ItemInnerSpacing.x);
                ImGui.TextEx(label, label_end);
            }

            ImGui.EndGroup();
            return valueChanged;
        }
    }
}