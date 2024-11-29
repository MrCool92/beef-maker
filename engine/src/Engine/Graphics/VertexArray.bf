namespace BeefMakerEngine
{
    public class VertexArray
    {
        private uint32 vertexArray;

        public this()
        {
            GL.glGenVertexArrays(1, &vertexArray);
        }

        public ~this()
        {
            GL.glDeleteVertexArrays(1, &vertexArray);
        }

        public void Bind()
        {
            GL.glBindVertexArray(vertexArray);
        }

        public void Unbind()
        {
            GL.glBindVertexArray(0);
        }
    }
}