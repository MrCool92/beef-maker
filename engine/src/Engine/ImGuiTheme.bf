using ImGui;

namespace BeefMakerEngine
{
    public static class ImGuiTheme
    {
        public static void Init()
        {
            var colors = ref ImGui.GetStyle().Colors;
            colors[(int)ImGui.Col.Text]                   = .(1.00f, 1.00f, 1.00f, 1.00f);
            colors[(int)ImGui.Col.TextDisabled]           = .(0.50f, 0.50f, 0.50f, 1.00f);
            colors[(int)ImGui.Col.WindowBg]               = .(0.10f, 0.10f, 0.10f, 1.00f);
            colors[(int)ImGui.Col.ChildBg]                = .(0.00f, 0.00f, 0.00f, 0.00f);
            colors[(int)ImGui.Col.PopupBg]                = .(0.19f, 0.19f, 0.19f, 0.97f);
            colors[(int)ImGui.Col.Border]                 = .(0.19f, 0.19f, 0.19f, 0.29f);
            colors[(int)ImGui.Col.BorderShadow]           = .(0.00f, 0.00f, 0.00f, 0.24f);
            colors[(int)ImGui.Col.FrameBg]                = .(0.05f, 0.05f, 0.05f, 0.54f);
            colors[(int)ImGui.Col.FrameBgHovered]         = .(0.19f, 0.19f, 0.19f, 0.54f);
            colors[(int)ImGui.Col.FrameBgActive]          = .(0.20f, 0.22f, 0.23f, 1.00f);
            colors[(int)ImGui.Col.TitleBg]                = .(0.00f, 0.00f, 0.00f, 1.00f);
            colors[(int)ImGui.Col.TitleBgActive]          = .(0.00f, 0.00f, 0.00f, 1.00f);
            colors[(int)ImGui.Col.TitleBgCollapsed]       = .(0.00f, 0.00f, 0.00f, 1.00f);
            colors[(int)ImGui.Col.MenuBarBg]              = .(0.14f, 0.14f, 0.14f, 1.00f);
            colors[(int)ImGui.Col.ScrollbarBg]            = .(0.05f, 0.05f, 0.05f, 0.54f);
            colors[(int)ImGui.Col.ScrollbarGrab]          = .(0.34f, 0.34f, 0.34f, 0.54f);
            colors[(int)ImGui.Col.ScrollbarGrabHovered]   = .(0.40f, 0.40f, 0.40f, 0.54f);
            colors[(int)ImGui.Col.ScrollbarGrabActive]    = .(0.56f, 0.56f, 0.56f, 0.54f);
            colors[(int)ImGui.Col.CheckMark]              = .(0.33f, 0.67f, 0.86f, 1.00f);
            colors[(int)ImGui.Col.SliderGrab]             = .(0.34f, 0.34f, 0.34f, 0.54f);
            colors[(int)ImGui.Col.SliderGrabActive]       = .(0.56f, 0.56f, 0.56f, 0.54f);
            colors[(int)ImGui.Col.Button]                 = .(0.25f, 0.25f, 0.25f, 0.52f);
            colors[(int)ImGui.Col.ButtonHovered]          = .(0.30f, 0.30f, 0.30f, 0.70f);
            colors[(int)ImGui.Col.ButtonActive]           = .(0.20f, 0.22f, 0.23f, 1.00f);
            colors[(int)ImGui.Col.Header]                 = .(0.25f, 0.25f, 0.25f, 0.52f);
            colors[(int)ImGui.Col.HeaderHovered]          = .(0.30f, 0.30f, 0.30f, 0.70f);
            colors[(int)ImGui.Col.HeaderActive]           = .(0.20f, 0.22f, 0.23f, 1.00f);
            colors[(int)ImGui.Col.Separator]              = .(0.28f, 0.28f, 0.28f, 0.29f);
            colors[(int)ImGui.Col.SeparatorHovered]       = .(0.44f, 0.44f, 0.44f, 0.29f);
            colors[(int)ImGui.Col.SeparatorActive]        = .(0.40f, 0.44f, 0.47f, 1.00f);
            colors[(int)ImGui.Col.ResizeGrip]             = .(0.28f, 0.28f, 0.28f, 0.29f);
            colors[(int)ImGui.Col.ResizeGripHovered]      = .(0.44f, 0.44f, 0.44f, 0.29f);
            colors[(int)ImGui.Col.ResizeGripActive]       = .(0.40f, 0.44f, 0.47f, 1.00f);
            colors[(int)ImGui.Col.Tab]                    = .(0.00f, 0.00f, 0.00f, 0.52f);
            colors[(int)ImGui.Col.TabHovered]             = .(0.14f, 0.14f, 0.14f, 1.00f);
            colors[(int)ImGui.Col.TabActive]              = .(0.20f, 0.20f, 0.20f, 0.36f);
            colors[(int)ImGui.Col.TabUnfocused]           = .(0.00f, 0.00f, 0.00f, 0.52f);
            colors[(int)ImGui.Col.TabUnfocusedActive]     = .(0.14f, 0.14f, 0.14f, 1.00f);
            colors[(int)ImGui.Col.DockingPreview]         = .(0.33f, 0.67f, 0.86f, 1.00f);
            colors[(int)ImGui.Col.DockingEmptyBg]         = .(0.19f, 0.19f, 0.19f, 1.00f);
            colors[(int)ImGui.Col.PlotLines]              = .(1.00f, 0.00f, 0.00f, 1.00f);
            colors[(int)ImGui.Col.PlotLinesHovered]       = .(1.00f, 0.00f, 0.00f, 1.00f);
            colors[(int)ImGui.Col.PlotHistogram]          = .(1.00f, 0.00f, 0.00f, 1.00f);
            colors[(int)ImGui.Col.PlotHistogramHovered]   = .(1.00f, 0.00f, 0.00f, 1.00f);
            colors[(int)ImGui.Col.TableHeaderBg]          = .(0.00f, 0.00f, 0.00f, 0.52f);
            colors[(int)ImGui.Col.TableBorderStrong]      = .(0.00f, 0.00f, 0.00f, 0.52f);
            colors[(int)ImGui.Col.TableBorderLight]       = .(0.28f, 0.28f, 0.28f, 0.29f);
            colors[(int)ImGui.Col.TableRowBg]             = .(0.00f, 0.00f, 0.00f, 0.00f);
            colors[(int)ImGui.Col.TableRowBgAlt]          = .(1.00f, 1.00f, 1.00f, 0.06f);
            colors[(int)ImGui.Col.TextSelectedBg]         = .(0.20f, 0.22f, 0.23f, 1.00f);
            colors[(int)ImGui.Col.DragDropTarget]         = .(0.33f, 0.67f, 0.86f, 1.00f);
            colors[(int)ImGui.Col.NavHighlight]           = .(1.00f, 0.00f, 0.00f, 1.00f);
            colors[(int)ImGui.Col.NavWindowingHighlight]  = .(1.00f, 0.00f, 0.00f, 0.70f);
            colors[(int)ImGui.Col.NavWindowingDimBg]      = .(1.00f, 0.00f, 0.00f, 0.20f);
            colors[(int)ImGui.Col.ModalWindowDimBg]       = .(1.00f, 0.00f, 0.00f, 0.35f);

            var style = ImGui.GetStyle();
            style.WindowPadding                     = .(8.00f, 8.00f);
            style.FramePadding                      = .(5.00f, 3.00f);
            style.CellPadding                       = .(4.00f, 4.00f);
            style.ItemSpacing                       = .(6.00f, 6.00f);
            style.ItemInnerSpacing                  = .(6.00f, 6.00f);
            style.TouchExtraPadding                 = .(0.00f, 0.00f);
            style.IndentSpacing                     = 25;
            style.ScrollbarSize                     = 15;
            style.GrabMinSize                       = 10;
            style.WindowBorderSize                  = 1;
            style.ChildBorderSize                   = 1;
            style.PopupBorderSize                   = 1;
            style.FrameBorderSize                   = 1;
            style.TabBorderSize                     = 1;
            style.WindowRounding                    = 1;
            style.ChildRounding                     = 1;
            style.FrameRounding                     = 1;
            style.PopupRounding                     = 1;
            style.ScrollbarRounding                 = 9;
            style.GrabRounding                      = 3;
            style.LogSliderDeadzone                 = 4;
            style.TabRounding                       = 4;
        }
    }
}