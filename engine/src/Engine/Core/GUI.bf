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

        public static bool Vector3Field(char8* label, ref Vector3 value, char8* format = "%.3f", float labelWidth = 100f)
        {
            bool valueChanged = false;

            ImGui.PushID(label);
            ImGui.Columns(2, null, false);
            ImGui.SetColumnWidth(0, labelWidth);

            ImGui.Text(label);

            ImGui.NextColumn();

            ImGui.PushMultiItemsWidths(3, ImGui.CalcItemWidth());

            ImGui.PushStyleColor(.FrameBg, .(1f, 0f, 0f, 0.4f));
            ImGui.PushStyleColor(.Border, .(1f, 0f, 0f, 0.8f));
            ImGui.PushStyleColor(.FrameBgActive, .(1f, 0f, 0f, 0.6f));
            ImGui.PushStyleColor(.FrameBgHovered, .(1f, 0f, 0f, 0.5f));
            valueChanged |= ImGui.DragFloat("##x", &value.x, 0.1f, 0f, 0f, "%.2f");
            ImGui.PopStyleColor(4);
            ImGui.PopItemWidth();

            ImGui.SameLine();
            ImGui.PushStyleColor(.FrameBg, .(0f, 1f, 0f, 0.4f));
            ImGui.PushStyleColor(.Border, .(0f, 1f, 0f, 0.8f));
            ImGui.PushStyleColor(.FrameBgActive, .(0f, 1f, 0f, 0.6f));
            ImGui.PushStyleColor(.FrameBgHovered, .(0f, 1f, 0f, 0.5f));
            valueChanged |= ImGui.DragFloat("##Y", &value.y, 0.1f, 0f, 0f, "%.2f");
            ImGui.PopStyleColor(4);
            ImGui.PopItemWidth();

            ImGui.SameLine();
            ImGui.PushStyleColor(.FrameBg, .(0f, 0f, 1f, 0.4f));
            ImGui.PushStyleColor(.Border, .(0f, 0f, 1f, 0.8f));
            ImGui.PushStyleColor(.FrameBgActive, .(0f, 0f, 1f, 0.6f));
            ImGui.PushStyleColor(.FrameBgHovered, .(0f, 0f, 1f, 0.5f));
            valueChanged |= ImGui.DragFloat("##Z", &value.z, 0.1f, 0f, 0f, "%.2f");
            ImGui.PopStyleColor(4);
            ImGui.PopItemWidth();

            ImGui.Columns(1);
            ImGui.PopID();

            return valueChanged;
        }
    }
}