using System;

namespace BeefMakerEngine
{
    public class Material
    {
        public Shader shader;

        public this(Shader shader)
        {
            this.shader = shader;
        }

        public void SetMatrix4x4(char8* name, Matrix4x4 value)
        {
            int propertyId = GL.glGetUniformLocation(shader.Program, name);
            GL.glUniformMatrix4fv(propertyId, 1, GL.GL_FALSE, value);
        }

        public void SetFloat3(char8* name, Vector3 value)
        {
            int propertyId = GL.glGetUniformLocation(shader.Program, name);
            GL.glUniform3fv(propertyId, 1, &value.x);
        }

        public void SetColor3(char8* name, Color value)
        {
            int propertyId = GL.glGetUniformLocation(shader.Program, name);
            GL.glUniform3fv(propertyId, 1, value);
        }

        public void SetColor4(char8* name, Color value)
        {
            int propertyId = GL.glGetUniformLocation(shader.Program, name);
            GL.glUniform4fv(propertyId, 1, value);
        }
    }
}