using System;
using ImGui;

namespace BeefMaker
{
	public class RenderTexture
	{
		private int width;
		public int Width => width;

		private int height;
		public int Height => height;

		private uint32 frameBuffer;

		private uint32 texture;
		public ImGui.TextureID TextureId => (void*)(int)texture;

		public this(int width, int height)
		{
			this.width = width;
			this.height = height;
			//int32 lastFrameBuffer = 0;
			//GL.glGetIntegerv(GL.GL_READ_FRAMEBUFFER_BINDING, &lastFrameBuffer);

			GL.glGenFramebuffers(1, &frameBuffer);
			GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, frameBuffer);

			GL.glGenTextures(1, &texture);
			GL.glBindTexture(GL.GL_TEXTURE_2D, texture);
			GL.glTexImage2D(GL.GL_TEXTURE_2D, 0, GL.GL_RGB, width, height, 0, GL.GL_RGBA, GL.GL_UNSIGNED_BYTE, null);
			GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
			GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
			GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_R, GL.GL_CLAMP_TO_EDGE);
			GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
			GL.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);
			GL.glFramebufferTexture2D(GL.GL_FRAMEBUFFER, GL.GL_COLOR_ATTACHMENT0, GL.GL_TEXTURE_2D, texture, 0);

			if (GL.glCheckFramebufferStatus(GL.GL_FRAMEBUFFER) == GL.GL_FRAMEBUFFER_COMPLETE)
			    Console.WriteLine("[GL] Framebuffer successfully created.");
			else
				Console.WriteLine("[GL] Error: framebuffer is not complete.");

			//GL.glBindFramebuffer(GL.GL_FRAMEBUFFER, (uint)lastFrameBuffer);
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