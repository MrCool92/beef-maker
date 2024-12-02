using ImGui;
using System;
using System.Collections;
using BeefMakerEngine;

namespace BeefMakerEditor
{
    public abstract class Editor
    {
        private static List<Editor> editors = new List<Editor>() ~ delete _;

        private static ~this()
        {
            for (var e in editors)
                delete e;
        }

        public static TEditor Create<TEditor>()
            where TEditor : Editor
        {
            var editorInstance = new TEditor();
            editors.Add(editorInstance);
            editorInstance.OnEnable();
            return editorInstance;
        }

        public static void Disable()
        {
            for (var editor in editors)
                editor.OnDisable();
        }

        public static void Update()
        {
            for (var editor in editors)
                editor.OnUpdate();
        }

        public static void Render()
        {
            for (var editor in editors)
                editor.OnRender();
        }

        public static void ImGui()
        {
            for (var editor in editors)
                editor.[Friend]ImGuiInternal();
        }

        protected String name;

        protected bool wantsToClose;

        public void* Ptr => Internal.UnsafeCastToPtr(this);

        public virtual void OnEnable()
        {
        }

        public virtual void OnDisable()
        {
        }

        public virtual void OnUpdate()
        {
        }

        public virtual void OnRender()
        {
        }

        public virtual void OnImGUI()
        {
        }

        private void ImGuiInternal()
        {
            ImGui.PushStyleVar(.WindowPadding, .(2f, 2f));
            ImGui.Begin(name);
            {
                if (ImGui.BeginPopupContextItem())
                {
                    if (ImGui.MenuItem("Close"))
                        wantsToClose = true;
                    ImGui.EndPopup();
                }

                OnImGUI();
            }
            ImGui.End();
            ImGui.PopStyleVar();
        }
    }
}