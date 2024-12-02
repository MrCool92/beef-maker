using System;
using ImGui;

namespace BeefMakerEngine
{
    public class RenderTexture
    {
        private int width;
        [Inline] public int Width => width;

        private int height;
        [Inline] public int Height => height;

        private uint32 frameBuffer;
        private uint32 depthBuffer;

        private uint32 texture;
        [Inline] public ImGui.TextureID TextureId => (void*)(int)texture;

        private bool ready;

        [Inline] public bool Ready => ready;

        public this(int width, int height)
        {
            this.width = width;
            this.height = height;

            // Generate and bind framebuffer
            GL.glGenFramebuffers(1, &frameBuffer);
            GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, frameBuffer);

            // Create the texture for rendering
            GL.glGenTextures(1, &texture);
            GL.glBindTexture(GL.GL_TEXTURE_2D, texture);
            GL.glTexImage2D(GL.GL_TEXTURE_2D, 0, GL.GL_RGBA, width, height, 0, GL.GL_RGBA, GL.GL_UNSIGNED_BYTE, null);
            GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
            GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
            GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_R, GL.GL_CLAMP_TO_EDGE);
            GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
            GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);

            // Attach the texture to the framebuffer as the color attachment
            GL.glFramebufferTexture2D(GL.GL_FRAMEBUFFER, GL.GL_COLOR_ATTACHMENT0, GL.GL_TEXTURE_2D, texture, 0);

            // Optional: Add a depth buffer
            /*GL.glGenRenderbuffers(1, &depthBuffer);
            GL.glBindRenderbuffer(GL.GL_RENDERBUFFER, depthBuffer);
            GL.glRenderbufferStorage(GL.GL_RENDERBUFFER, GL.GL_DEPTH_COMPONENT24, width, height);
            GL.glFramebufferRenderbuffer(GL.GL_FRAMEBUFFER, GL.GL_DEPTH_ATTACHMENT, GL.GL_RENDERBUFFER, depthBuffer);*/

            ready = GL.glCheckFramebufferStatus(GL.GL_FRAMEBUFFER) == GL.GL_FRAMEBUFFER_COMPLETE;
            if (ready)
                Console.WriteLine("[GL] Framebuffer successfully created.");
            else
                Console.WriteLine("[GL] Error: framebuffer is not complete.");

            // Unbind framebuffer to avoid accidental usage
            GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, 0);
        }


        public ~this()
        {
            GL.glDeleteFramebuffers(1, &frameBuffer);
            GL.glDeleteTextures(1, &texture);
        }

        public void Bind()
        {
            GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, frameBuffer);
            GL.glViewport(0, 0, width, height);
        }

        public void Unbind()
        {
            GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, 0);
        }

        public void Clear()
        {
            GL.glClearColor(0f, 0f, 0f, 1f);
            GL.glClear(GL.GL_COLOR_BUFFER_BIT);
        }
    }
}