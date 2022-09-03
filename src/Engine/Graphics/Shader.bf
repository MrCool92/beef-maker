using System;
using System.IO;

namespace BeefMaker
{
	public class Shader
	{
		private ShaderProgramSource source;
		private uint shader;

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
			source = ParseShader(filepath);
			shader = CreateShader(source.verxtexSource, source.fragmentSource);
		}

		public ~this()
		{
			delete source.verxtexSource;
			delete source.fragmentSource;
			GL.glDeleteProgram(shader);
		}

		public void Use()
		{
			GL.glUseProgram(shader);
		}

		public static ShaderProgramSource ParseShader(StringView filepath)
		{
			FileStream fs = scope FileStream();

			var result = fs.Open(filepath, .Read, .None, 4096, .None, null);
			if (result == .Ok)
			{
				StreamReader sr = scope StreamReader(fs);
				StringStream[] ss = scope StringStream[2] (
					scope StringStream(),
					scope StringStream(),
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
							var s = ss[(int)type];
							s.Write(line);
							s.Write('\n');
						}
					}
				}
				ShaderProgramSource shader = .() {
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