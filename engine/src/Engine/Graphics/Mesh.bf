namespace BeefMakerEngine
{
	public class Mesh
	{
		private uint32 vertexArray;
		private uint32 vertexBuffer;
		private float[] vertices ~ delete _;
		private uint32 indexBuffer;
		private uint32[] indicies ~ delete _;

		public this(float[] vertices, uint32[] indicies)
		{
			GL.glGenVertexArrays(1, &vertexArray);
			GL.glBindVertexArray(vertexArray);

			GL.glGenBuffers(1, &vertexBuffer);
			GL.glBindBuffer(GL.GL_ARRAY_BUFFER, vertexBuffer);

			this.vertices = vertices;
			GL.glBufferData(GL.GL_ARRAY_BUFFER, vertices.Count * sizeof(float), vertices.Ptr, GL.GL_STATIC_DRAW);

			GL.glEnableVertexAttribArray(0);
			GL.glVertexAttribPointer(0, 3, GL.GL_FLOAT, GL.GL_FALSE, 3 * sizeof(float), (void*)0);

			GL.glGenBuffers(1, &indexBuffer);
			GL.glBindBuffer(GL.GL_ELEMENT_ARRAY_BUFFER, indexBuffer);

			this.indicies = indicies;
			GL.glBufferData(GL.GL_ELEMENT_ARRAY_BUFFER, indicies.Count * sizeof(uint32), indicies.Ptr, GL.GL_STATIC_DRAW);
		}

		public ~this()
		{
			GL.glDeleteBuffers(1, &vertexBuffer);
			GL.glDeleteBuffers(1, &indexBuffer);
			GL.glDeleteVertexArrays(1, &vertexArray);
		}

		public void Render()
		{
			GL.glBindBuffer(GL.GL_ARRAY_BUFFER, vertexBuffer);
			GL.glDrawElements(GL.GL_TRIANGLES, 3, GL.GL_UNSIGNED_INT, null);
		}
	}
}