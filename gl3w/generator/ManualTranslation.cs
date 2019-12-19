using System.IO;
using System.Linq;

namespace Generator
{
	public static class ManualTranslation
	{
		static string[] MethodsWithManualCImpl = new string[] { };
		static string[] MethodsWithManualVImpl = new string[] { "glGetProgramInfoLog", "glGetShaderInfoLog",
		"glGetShaderiv", "glGetProgramiv", "glGetActiveUniform", "glGetActiveAttrib", "glBufferData", "glGetString",
		"glGetStringi", "glGenBuffers", "glGenVertexArrays", "glGenTextures" };

		public static bool HasManualCImplementation(string name) => MethodsWithManualCImpl.Contains(name);

		public static bool HasManualVImplementation(string name) => MethodsWithManualVImpl.Contains(name);

		public static void WriteVMethod(StreamWriter writer, string name)
		{
			if (name == "glGetProgramInfoLog")
			{
				writer.WriteLine("pub fn get_program_info_log(program u32) string {");
				writer.WriteLine("\tif !C.glIsProgram(program) {");
				writer.WriteLine("\t\tprintln('program $program is not a shader program')");
				writer.WriteLine("\t\texit(1)");
				writer.WriteLine("\t}");
				writer.WriteLine();
                writer.WriteLine("\tlength := 0");
				writer.WriteLine("\tinfo_log := [512]byte");
				writer.WriteLine("\tC.glGetProgramInfoLog(program, 512, &length, info_log)");
				writer.WriteLine("\treturn tos_clone(info_log)");
				writer.WriteLine("}");
			}
			else if (name == "glGetShaderInfoLog")
			{
				writer.WriteLine("pub fn get_shader_info_log(shader u32) string {");
				writer.WriteLine("\tif !C.glIsShader(shader) {");
				writer.WriteLine("\t\tprintln('shader $shader is not a shader')");
				writer.WriteLine("\t\texit(1)");
				writer.WriteLine("\t}");
				writer.WriteLine();
                writer.WriteLine("\tlength := 0");
				writer.WriteLine("\tinfo_log := [512]byte");
				writer.WriteLine("\tC.glGetShaderInfoLog(shader, 512, &length, info_log)");
				writer.WriteLine("\treturn tos_clone(info_log)");
				writer.WriteLine("}");
			}
			else if (name == "glGetShaderiv")
			{
				writer.WriteLine("pub fn get_shaderiv(shader u32, pname int) int {");
				writer.WriteLine("\tsuccess := 0");
				writer.WriteLine("\tC.glGetShaderiv(shader, pname, &success)");
				writer.WriteLine("\treturn success");
				writer.WriteLine("}");
				writer.WriteLine();
				writer.WriteLine("pub fn get_shader_compile_status(shader u32) int {");
				writer.WriteLine("\tsuccess := 0");
				writer.WriteLine("\tC.glGetShaderiv(shader, C.GL_COMPILE_STATUS, &success)");
				writer.WriteLine("\treturn success");
				writer.WriteLine("}");
			}
			else if (name == "glGetProgramiv")
			{
				writer.WriteLine("pub fn get_programiv(program u32, pname int) int {");
				writer.WriteLine("\tsuccess := 0");
				writer.WriteLine("\tC.glGetProgramiv(program, pname, &success)");
				writer.WriteLine("\treturn success");
				writer.WriteLine("}");
				writer.WriteLine();
				writer.WriteLine("pub fn get_program_link_status(program u32) int {");
				writer.WriteLine("success := 0");
				writer.WriteLine("C.glGetProgramiv(program, C.GL_LINK_STATUS, &success)");
				writer.WriteLine("return success");
				writer.WriteLine("}");
			}
			else if (name == "glGetActiveUniform")
			{
				writer.WriteLine("// returns name, size, type");
				writer.WriteLine("pub fn get_active_uniform(program u32, index u32) (string, int, int) {");
				writer.WriteLine("\tbuffer := [100]byte");
				writer.WriteLine("\tlength := 0");
				writer.WriteLine("\ttyp := 0");
				writer.WriteLine("\tsize := 0");
				writer.WriteLine("\tC.glGetActiveUniform(program, index, 100, &length, &size, &typ, buffer)");
				writer.WriteLine("\treturn tos_clone(buffer), size, typ");
				writer.WriteLine("}");
			}
			else if (name == "glGetActiveAttrib")
			{
				writer.WriteLine("// returns name, size, type");
				writer.WriteLine("pub fn get_active_attrib(program u32, index u32) (string, int, int) {");
				writer.WriteLine("\tbuffer := [100]byte");
				writer.WriteLine("\tlength := 0");
				writer.WriteLine("\ttyp := 0");
				writer.WriteLine("\tsize := 0");
				writer.WriteLine("\tC.glGetActiveAttrib(program, index, 100, &length, &size, &typ, buffer)");
				writer.WriteLine("\treturn tos_clone(buffer), size, typ");
				writer.WriteLine("}");
			}
			else if (name == "glBufferData")
			{
				writer.WriteLine("pub fn buffer_data(target int, size int, data voidptr, usage int) {");
				writer.WriteLine("\tC.glBufferData(target, size, data, usage)");
				writer.WriteLine("}");
				writer.WriteLine();
				writer.WriteLine("pub fn buffer_data_int(target int, data []int, usage int) {");
				writer.WriteLine("\tC.glBufferData(target, data.len * sizeof(int), data.data, usage)");
				writer.WriteLine("}");
				writer.WriteLine();
				writer.WriteLine("pub fn buffer_data_u16(target int, data []u16, usage int) {");
				writer.WriteLine("\tC.glBufferData(target, data.len * sizeof(u16), data.data, usage)");
				writer.WriteLine("}");
				writer.WriteLine();
				writer.WriteLine("pub fn buffer_data_u32(target int, data []u32, usage int) {");
				writer.WriteLine("\tC.glBufferData(target, data.len * sizeof(u32), data.data, usage)");
				writer.WriteLine("}");
				writer.WriteLine();
				writer.WriteLine("pub fn buffer_data_f32(target int, data []f32, usage int) {");
				writer.WriteLine("\tC.glBufferData(target, data.len * sizeof(f32), data.data, usage)");
				writer.WriteLine("}");
			}
			else if (name == "glGetString")
			{
				writer.WriteLine("pub fn get_string(name int) string {");
				writer.WriteLine("\treturn tos2(glGetString(name))");
				writer.WriteLine("}");
			}
			else if (name == "glGetStringi")
			{
				writer.WriteLine("pub fn get_stringi(index u32) string {");
				writer.WriteLine("\treturn tos2(glGetStringi(GL_EXTENSIONS, index))");
				writer.WriteLine("}");
			}
			else if (name == "glGenBuffers")
			{
				writer.WriteLine("pub fn gen_buffers(n int, buffers &u32) {");
				writer.WriteLine("\tC.glGenBuffers(n, buffers)");
				writer.WriteLine("}");
				writer.WriteLine();
				writer.WriteLine("pub fn gen_buffer() u32 {");
				writer.WriteLine("\tvbo := u32(0)");
				writer.WriteLine("\tC.glGenBuffers(1, &vbo)");
				writer.WriteLine("\treturn vbo");
				writer.WriteLine("}");
			}
			else if (name == "glGenVertexArrays")
			{
				writer.WriteLine("pub fn gen_vertex_arrays(n int, arrays []u32) {");
				writer.WriteLine("\tC.glGenVertexArrays(n, arrays.data)");
				writer.WriteLine("}");
                writer.WriteLine();
				writer.WriteLine("pub fn gen_vertex_array() u32 {");
				writer.WriteLine("\tvao := u32(0)");
				writer.WriteLine("\tC.glGenVertexArrays(1, &vao)");
				writer.WriteLine("\treturn vao");
				writer.WriteLine("}");
			}
			else if (namem == "glGenTextures")
			{
				writer.WriteLine("pub fn gen_textures(n int, textures []u32) {");
				writer.WriteLine("\tC.glGenTextures(n, textures.data)");
				writer.WriteLine("}");
				writer.WriteLine();
				writer.WriteLine("pub fn gen_texture() u32 {");
				writer.WriteLine("\tex := u32(0)");
				writer.WriteLine("\tC.glGenTextures(1, &tex)");
				writer.WriteLine("\treturn tex");
				writer.WriteLine("}");
			}
			else
			{
				throw new System.Exception($"Unhandled method: {name}");
			}
		}

		public static void WriteCMethod(StreamWriter writer, string name)
		{

		}
	}
}