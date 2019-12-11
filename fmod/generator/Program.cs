using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

namespace Generator
{
	#region Helper Types

	class Method
	{
		public string Name;
		public string ReturnType;
		public List<Parameter> Parameters = new List<Parameter>();
	}

	class Parameter
	{
		public string Name;
		public string Type;
		public bool IsConst;
		public bool HasPtr;
        public bool HasDoublePtr;
	}

	class StructsAndTypes
	{
		public List<Struct> Structs = new List<Struct>();
		public List<Const> Consts = new List<Const>();
		public List<TypeDef> TypeDefs = new List<TypeDef>();
        public List<Enum> Enums = new List<Enum>();
	}

	public class Const
	{
		public string Name, Value;
	}

	class Struct
	{
		public string Name;
		public List<Parameter> Parameters = new List<Parameter>();
	}

    class Enum
    {
        public string Name;
        public List<string> Enums = new List<string>();
    }

	public class TypeDef
	{
		public string Type, FMODType;
	}

	#endregion

	class Program
	{
		static string RootDir
		{
			get
			{
				var dllPath = System.Reflection.Assembly.GetAssembly(typeof(Program)).Location;
				return Directory.GetParent(Path.GetDirectoryName(dllPath)).Parent.Parent.Parent.FullName;
			}
		}

		static void Main(string[] args)
		{
			var sourceDir = Path.Combine(RootDir, "thirdparty");

			var methods = ExtractMethods(Path.Combine(sourceDir, "core/fmod.h"));
			using (var writer = new StreamWriter(File.Open(Path.Combine(RootDir, "c_funcs_fmod.v"), System.IO.FileMode.Create)))
				WriteMethodsToFile(writer, methods);

			var types = ExtractStructsAndTypes(Path.Combine(sourceDir, "core/fmod_common.h"));
			using (var writer = new StreamWriter(File.Open(Path.Combine(RootDir, "c_structs_fmod.v"), System.IO.FileMode.Create)))
				WriteTypesToFile(writer, types);

			types = ExtractStructsAndTypes(Path.Combine(sourceDir, "core/fmod_dsp_effects.h"));
			using (var writer = new StreamWriter(File.Open(Path.Combine(RootDir, "c_structs_dsp_effects.v"), System.IO.FileMode.Create)))
				WriteTypesToFile(writer, types);

			types = ExtractStructsAndTypes(Path.Combine(sourceDir, "core/fmod_dsp.h"));
			using (var writer = new StreamWriter(File.Open(Path.Combine(RootDir, "c_structs_dsp.v"), System.IO.FileMode.Create)))
				WriteTypesToFile(writer, types);

			types = ExtractStructsAndTypes(Path.Combine(sourceDir, "core/fmod_codec.h"));
			using (var writer = new StreamWriter(File.Open(Path.Combine(RootDir, "c_structs_codec.v"), System.IO.FileMode.Create)))
				WriteTypesToFile(writer, types);

			types = ExtractStructsAndTypes(Path.Combine(sourceDir, "core/fmod_output.h"));
			using (var writer = new StreamWriter(File.Open(Path.Combine(RootDir, "c_structs_output.v"), System.IO.FileMode.Create)))
				WriteTypesToFile(writer, types);
		}

		#region Method Handling

		static List<Method> ExtractMethods(string src)
		{
			var methods = new List<Method>();
			var lastLineWithMethod = 0;
			string lastComment = null;

			var lines = File.ReadAllLines(src);
			for (var i = 0; i < lines.Length; i++)
			{
				var line = lines[i];
				if (line.StartsWith("FMOD_RESULT F_API") || line.StartsWith("FMOD_BOOL "))
				{
					// was our last line a method as well? If not, we can find a comment above us
					if (lastLineWithMethod != i - 1)
					{
						lastComment = ExtractLastComment(lines, i - 1);
					}

					lastLineWithMethod = i;
					line = line.Replace("F_API", "");
					methods.Add(ParseMethod(line));
				}
			}

			return methods;
		}

		static string ExtractLastComment(string[] lines, int i)
		{
			while (!lines[i].Contains("/*"))
				i--;

			// if the entire line is just the comment delimiter, we want the next line
			if (lines[i].Length == 2)
			{
				i++;
				return lines[i].Trim();
			}
			else
			{
				var line = lines[i].Trim('/', '*', '\\').Trim();
				return line;
			}
		}

		static Method ParseMethod(string line)
		{
			var method = new Method();

			// find return type and name
			var parts = line.Substring(0, line.IndexOf("(")).Split(' ', StringSplitOptions.RemoveEmptyEntries);
			method.Name = parts[1];
			method.ReturnType = parts[0];

			var paramChunk = line.Substring(line.IndexOf("(") + 1).TrimEnd(';', ')', ' ');
			var paramParts = paramChunk.Split(", ", StringSplitOptions.RemoveEmptyEntries);

			foreach (var part in paramParts)
			{
				if (part.Contains("&"))
				{
					throw new Exception("hi");
				}

				var typeName = part.Replace("*", "").Replace("const", "").Replace("unsigned ", "unsigned").Trim().Split(' ');
				var hasPtr = part.Contains('*');
                var hasDoublePtr = part.Contains("**");
				if (hasPtr && typeName[0] == "void")
				{
					hasPtr = false;
					typeName[0] = hasDoublePtr ? "void**" : "void*";
				}

				method.Parameters.Add(new Parameter
				{
					Name = EscapeReservedWords(typeName[1].Trim()),
					Type = typeName[0].Trim(),
					IsConst = part.Contains("const"),
					HasPtr = hasPtr,
                    HasDoublePtr = hasDoublePtr
				});

				if (typeName[0].Trim().Length == 0)
				{

				}
			}

			return method;
		}

		static void WriteMethodsToFile(StreamWriter writer, List<Method> methods)
		{
			writer.WriteLine("module fmod");
			writer.WriteLine();

			foreach (var m in methods)
			{
                foreach (var p in m.Parameters)
                {
                    if (p.Type.Contains("_CALLBACK"))
                    {
                        writer.Write("// ");
                        break;
                    }
                }
				writer.Write($"fn C.{m.Name}(");

				for (var i = 0; i < m.Parameters.Count; i++)
				{
					var p = m.Parameters[i];
					var typePrefix = p.HasPtr ? "&" : "";
					writer.Write($"{p.Name} {typePrefix}{Statics.GetVTypeForCType(p.Type)}");

					if (i < m.Parameters.Count - 1)
						writer.Write(", ");
				}

				writer.WriteLine($") {Statics.GetVTypeForCType(m.ReturnType)}");
			}
		}

		#endregion

		#region Type Handling

		static StructsAndTypes ExtractStructsAndTypes(string src)
		{
			var types = new StructsAndTypes();

			var lines = File.ReadAllLines(src);
			for (var i = 0; i < lines.Length; i++)
			{
				var line = lines[i];

				if (line.StartsWith("typedef struct"))
				{
					if (line.EndsWith(";"))
					{
						types.Structs.Add(new Struct
						{
							Name = Regex.Match(line, @"([A-Z0-9_]+);$").Groups[1].Value
						});
					}
                    else
                    {
                        types.Structs.Add(ExtractStruct(lines, ref i));
                    }
				}
				else if (line.StartsWith("typedef enum"))
				{
                    types.Enums.Add(ExtractEnum(lines, ref i));
				}
				else if (line.StartsWith("#define"))
				{
					var parts = line.Replace("#define ", "").Split(' ', StringSplitOptions.RemoveEmptyEntries);
					if (parts.Length == 2 && parts[1].StartsWith("0x"))
					{
						types.Consts.Add(new Const
						{
							Name = EscapeReservedWords(parts[0]),
							Value = parts[1]
						});
					}
				}
				else if (line.StartsWith("typedef"))
				{
					//typedef unsigned int FMOD_DRIVER_STATE;
					var fmodType = Regex.Match(line, @"([A-Z0-9_]+);$").Groups[1].Value;
					if (!string.IsNullOrEmpty(fmodType))
					{
						var t = line.Replace(fmodType, "").Replace("typedef", "").TrimEnd(';').Trim();
						types.TypeDefs.Add(new TypeDef
						{
							Type = t.Replace(" ", ""),
							FMODType = fmodType
						});
					}
                    else
                    {
                        // this is the callback function typedefs
                        var name = Regex.Match(line, @".*?\(F_CALL \*([A-Z0-9_]+)").Groups[1].Value;
                        // types.TypeDefs.Add(new TypeDef
                        // {
                        //     Type = "fn()",
                        //     FMODType = name
                        // });

                        // typedef FMOD_RESULT (F_CALLBACK *FMOD_CODEC_OPEN_CALLBACK)         (FMOD_CODEC_STATE *codec_state, FMOD_MODE usermode, FMOD_CREATESOUNDEXINFO *userexinfo);
                        if (string.IsNullOrEmpty(name))
                        {
                            name = Regex.Match(line, @".*?\(F_CALLBACK \*([A-Z0-9_]+)").Groups[1].Value;
                        }
                    }
				}
			}

			return types;
		}

        static Struct ExtractStruct(string[] lines, ref int i)
        {
            var s = new Struct
            {
                Name = lines[i].Replace("typedef struct", "").Trim()
            };



            return s;
        }

        static Enum ExtractEnum(string[] lines, ref int i)
        {
            var e = new Enum
            {
                Name = lines[i++].Replace("typedef enum", "").Trim()
            };

            do
            {
                if (lines[i].StartsWith("{") || lines[i].Contains("FORCEINT"))
                    continue;

                if (lines[i] == "")
                    continue;

                e.Enums.Add(lines[i].Trim().TrimEnd(','));
            } while (!lines[++i].StartsWith("}"));

            if (string.IsNullOrEmpty(e.Name))
                e.Name = lines[i].TrimStart(' ', '}').TrimEnd(';');

            return e;
        }

		static void WriteTypesToFile(StreamWriter writer, StructsAndTypes types)
		{
			writer.WriteLine("module fmod");
			writer.WriteLine();

			writer.WriteLine("pub const (");
			foreach (var c in types.Consts)
				writer.WriteLine($"\t{c.Name} = {c.Value}");
			writer.WriteLine(")");

			writer.WriteLine();

			foreach (var t in types.TypeDefs)
			{
				writer.WriteLine($"type {t.FMODType} {Statics.GetVTypeForCType(t.Type)}");
			}

			writer.WriteLine();

			foreach (var s in types.Structs)
			{
				if (s.Parameters.Count == 0)
				{
					writer.WriteLine($"struct C.{s.Name} {{}}");
					continue;
				}
                writer.WriteLine();
			}

            writer.WriteLine();

            // foreach (var e in types.Enums)
            // {
            //     writer.WriteLine($"enum {e.Name} {{");
            //     foreach (var name in e.Enums)
            //         writer.WriteLine($"\t{name}");
            //     writer.WriteLine("}");
            //     writer.WriteLine();
            // }
		}

		#endregion

		static string EscapeReservedWords(string name)
		{
			if (name == "map")
				return "map";
			if (name == "string")
				return "str";
            if (name == "type")
                return "typ";
			return name;
		}
	}
}
