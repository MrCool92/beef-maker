using System;
using System.IO;
using System.Collections;

namespace BeefMakerEngine
{
    public class Shader
    {
        private String filepath ~ delete _;
        private ShaderProgramSource source;
        private uint program;
        private Dictionary<StringView, int> locationCache ~ delete _;

        public uint Program => program;

        public struct ShaderProgramSource
        {
            public String verxtexSource;
            public String fragmentSource;
        }

        public enum ShaderType
        {
            None = -1,
            Vertex,
            Fragment,
        }

        public this(StringView filepath)
        {
            this.filepath = new String(filepath);
            locationCache = new Dictionary<StringView, int>();
            source = ParseShader(filepath);
            program = CreateShader(source.verxtexSource, source.fragmentSource);
        }

        public ~this()
        {
            delete source.verxtexSource;
            delete source.fragmentSource;
            GL.glDeleteProgram(program);
        }

        public void Bind()
        {
            GL.glUseProgram(program);
        }

        public void Unbind()
        {
            GL.glUseProgram(0);
        }

        public void SetUniform1f(int location, float v0)
        {
            GL.glUniform1f(location, v0);
        }

        public void SetUniform1f(StringView name, float v0)
        {
            GL.glUniform1f(GetUniformLocation(name), v0);
        }

        public void SetUniform2f(int location, float v0, float v1)
        {
            GL.glUniform2f(location, v0, v1);
        }

        public void SetUniform2f(StringView name, float v0, float v1)
        {
            GL.glUniform2f(GetUniformLocation(name), v0, v1);
        }

        public void SetUniform3f(int location, float v0, float v1, float v2)
        {
            GL.glUniform3f(location, v0, v1, v2);
        }

        public void SetUniform3f(StringView name, float v0, float v1, float v2)
        {
            GL.glUniform3f(GetUniformLocation(name), v0, v1, v2);
        }

        public void SetUniform4f(int location, float v0, float v1, float v2, float v3)
        {
            GL.glUniform4f(location, v0, v1, v2, v3);
        }

        public void SetUniform4f(StringView name, float v0, float v1, float v2, float v3)
        {
            GL.glUniform4f(GetUniformLocation(name), v0, v1, v2, v3);
        }

        public int GetUniformLocation(StringView name)
        {
            if (locationCache.ContainsKey(name))
                return locationCache[name];

            let location = GL.glGetUniformLocation(program, name.ToScopeCStr!());
            if (location == -1)
                Console.WriteLine($"[Shader] Warning: uniform '{name}' doesn't exist!");
            locationCache[name] = location;
            return location;
        }

        public static ShaderProgramSource ParseShader(StringView filepath)
        {
            FileStream fs = scope FileStream();

            var result = fs.Open(filepath, .Read, .None, 4096, .None, null);
            if (result == .Ok)
            {
                StreamReader sr = scope .(fs);
                StringStream[] ss = scope .(
                    scope .(), // vertex
                    scope .() // fragment
                    );

                ShaderType type = .None;
                for	(StringView line in sr.Lines)
                {
                    if (line.Contains("#shader"))
                    {
                        if (line.Contains("vertex"))
                            type = .Vertex;
                        else if (line.Contains("fragment"))
                            type = .Fragment;
                    }
                    else
                    {
                        if (type != .None)
                        {
                            StringStream s = ss[(int)type];
                            s.Write(line);
                            s.Write('\n');
                        }
                    }
                }
                ShaderProgramSource shader = .()
                    {
                        verxtexSource = new String(ss[0].Content),
                        fragmentSource = new String(ss[1].Content)
                    };
                return shader;
            }
            return default;
        }

        public static uint CreateShader(StringView vertexShader, StringView fragmentShader)
        {
            uint program = GL.glCreateProgram();
            uint vs = CompileShader(GL.GL_VERTEX_SHADER, vertexShader);
            uint fs = CompileShader(GL.GL_FRAGMENT_SHADER, fragmentShader);

            GL.glAttachShader(program, vs);
            GL.glAttachShader(program, fs);
            GL.glLinkProgram(program);
            GL.glValidateProgram(program);

            GL.glDeleteShader(vs);
            GL.glDeleteShader(fs);
            return program;
        }

        public static uint CompileShader(uint type, StringView source)
        {
            uint id = GL.glCreateShader(type);
            char8* src = source.ToScopeCStr!();
            GL.glShaderSource(id, 1, &src, null);
            GL.glCompileShader(id);

            int32 result = 0;
            GL.glGetShaderiv(id, GL.GL_COMPILE_STATUS, &result);
            if (result == GL.GL_FALSE)
            {
                int32 length = 0;
                GL.glGetShaderiv(id, GL.GL_INFO_LOG_LENGTH, &length);
                char8[] message = scope char8[length];
                GL.glGetShaderInfoLog(id, length, &length, message.Ptr);

                Console.WriteLine($"[Shader] Failed to compile {(type == GL.GL_VERTEX_SHADER ? "vertex" : "fragment")} shader");
                Console.WriteLine(scope StringView(message, 0, length));

                GL.glDeleteShader(id);
                return 0;
            }

            return id;
        }
    }
}