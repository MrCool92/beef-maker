using BeefMakerEngine;
using ImGui;
using System;
using System.Collections;

namespace BeefMakerEditor
{
    public class Console : Editor
    {
        private String inputBuffer = new String() ~ delete _;
        private List<String> items = new List<String>() ~ delete _;
        private List<String> commands = new List<String>() ~ delete _;
        private List<String> history = new List<String>() ~ delete _;
        private int historyPos;
        private ImGui.TextFilter filter;
        private bool autoScroll;
        private bool scrollToBottom;

        public this()
        {
            name = "Console";

            historyPos = -1;

            commands.Add("HELP");
            commands.Add("HISTORY");
            commands.Add("CLEAR");
            commands.Add("CLASSIFY");
            autoScroll = true;
            scrollToBottom = false;
            //AddLog("Welcome to Dear ImGui!");
        }

        ~this()
        {
            ClearLog();

            for (int i = 0; i < history.Count; i++)
                delete history[i];
        }

        public void ClearLog()
        {
            for (int i = 0; i < history.Count; i++)
                delete history[i];

            items.Clear();
        }

        public override void OnImGUI()
        {
            if (ImGui.SmallButton("Clear"))
                ClearLog();

            ImGui.Separator();

            // Reserve enough left-over height for 1 separator + 1 input text
            float footer_height_to_reserve = ImGui.GetStyle().ItemSpacing.y + ImGui.GetFrameHeightWithSpacing();
            if (ImGui.BeginChild("ScrollingRegion", .(0, -footer_height_to_reserve), false, .NavFlattened | .HorizontalScrollbar))
            {
                if (ImGui.BeginPopupContextWindow())
                {
                    if (ImGui.Selectable("Clear"))
                        ClearLog();

                    ImGui.EndPopup();
                }

                ImGui.PushStyleVar(.ItemSpacing, .(4, 1));

                for (var item in items)
                {
                    if (!filter.PassFilter(item))
                        continue;

                    ImGui.Color color = .();
                    bool hasColor = false;

                    if (item.StartsWith("[error]"))
                    {
                        color = .(1.0f, 0.4f, 0.4f, 1.0f);
                        hasColor = true;
                    }

                    else if (item.StartsWith("# "))
                    {
                        color = .(1.0f, 0.8f, 0.6f, 1.0f);
                        hasColor = true;
                    }

                    if (hasColor)
                        ImGui.PushStyleColor(.Text, color.Value);

                    ImGui.TextUnformatted(item);
                    if (hasColor)
                        ImGui.PopStyleColor();
                }

                if (scrollToBottom || (autoScroll && ImGui.GetScrollY() >= ImGui.GetScrollMaxY()))
                    ImGui.SetScrollHereY(1.0f);

                scrollToBottom = false;

                ImGui.PopStyleVar();
            }
            ImGui.EndChild();
            ImGui.Separator();

            // Command-line
            bool reclaim_focus = false;
            ImGui.InputTextFlags input_text_flags = .EnterReturnsTrue | .CallbackCompletion | .CallbackHistory;
            if (ImGui.InputText("Input", inputBuffer.CStr(), (uint64)inputBuffer.AllocSize, input_text_flags, => CommandLineCallback, this.Ptr))
            {
                /*char * s = InputBuf;
                Strtrim(s);
                if (s[0])
                        ExecCommand(s);
                strcpy(s, "");
                reclaim_focus = true;*/
            }

            // Auto-focus on window apparition
            ImGui.SetItemDefaultFocus();
            if (reclaim_focus)
                ImGui.SetKeyboardFocusHere(-1); // Auto focus previous widget
        }

        private static int CommandLineCallback(ImGui.InputTextCallbackData* data)
        {
            var console = *(BeefMakerEditor.Console*)data.UserData;
            return console.TextEditCallback(data);
        }

        private int TextEditCallback(ImGui.InputTextCallbackData* data)
        {
            return 0;
        }
    }
}