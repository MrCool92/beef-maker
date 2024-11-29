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
            // Store data
            this.vertices = vertices;
            this.indicies = indicies;

            // Create and bind Vertex Array
            GL.glGenVertexArrays(1, &vertexArray);
            GL.glBindVertexArray(vertexArray);

            // Create and bind Vertex Buffer
            GL.glGenBuffers(1, &vertexBuffer);
            GL.glBindBuffer(GL.GL_ARRAY_BUFFER, vertexBuffer);
            GL.glBufferData(GL.GL_ARRAY_BUFFER, vertices.Count * sizeof(float), vertices.Ptr, GL.GL_STATIC_DRAW);

            // Set up vertex attributes
            GL.glEnableVertexAttribArray(0);
            GL.glVertexAttribPointer(0, 3, GL.GL_FLOAT, GL.GL_FALSE, 3 * sizeof(float), (void*)0);

            // Create and bind Index Buffer
            GL.glGenBuffers(1, &indexBuffer);
            GL.glBindBuffer(GL.GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
            GL.glBufferData(GL.GL_ELEMENT_ARRAY_BUFFER, indicies.Count * sizeof(uint32), indicies.Ptr, GL.GL_STATIC_DRAW);

            // Unbind to avoid accidental modification
            GL.glBindVertexArray(0);
        }

        public ~this()
        {
            // Clean up OpenGL resources
            GL.glDeleteBuffers(1, &vertexBuffer);
            GL.glDeleteBuffers(1, &indexBuffer);
            GL.glDeleteVertexArrays(1, &vertexArray);
        }

        public void Render()
        {
            // Ensure the correct VAO is bound and issue draw call
            GL.glBindVertexArray(vertexArray);
            GL.glBindBuffer(GL.GL_ARRAY_BUFFER, vertexBuffer);
            GL.glDrawElements(GL.GL_TRIANGLES, indicies.Count, GL.GL_UNSIGNED_INT, null);
        }
    }
}