using System.Collections.Generic;
using System.IO;

namespace Generator
{
    partial class Program
    {
        static void WriteMethodBagToFile(StreamWriter writer, MethodBag methods, string module)
        {
            writer.WriteLine($"module {module}");
            writer.WriteLine();

            foreach (var kvPair in methods)
            {
                writer.WriteLine($"// {kvPair.Key}");
                WriteMethodsToFile(writer, kvPair.Value);
                writer.WriteLine();
            }
        }

        static void WriteMethodsToFile(StreamWriter writer, List<Method> methods)
        {
            foreach (var m in methods)
            {
                foreach (var p in m.Parameters)
                {
                    if (p.Type.Contains("_CALLBACK") || p.Type.Contains("DSP") || p.Type.Contains("GEOMETRY"))
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

        static void WriteTypesToFile(StreamWriter writer, StructsAndTypes types, string module)
        {
            writer.WriteLine($"module {module}");
            writer.WriteLine();

            // writer.WriteLine("pub const (");
            // foreach (var c in types.Consts)
            //     writer.WriteLine($"\t{c.Name} = {c.Value}");
            // writer.WriteLine(")");

            // writer.WriteLine();

            foreach (var t in types.TypeDefs)
            {
                writer.WriteLine($"type {t.FMODType} {Statics.GetVTypeForCType(t.Type)}");
            }

            writer.WriteLine();

            foreach (var s in types.Structs)
            {
                if (s.Parameters.Count == 0)
                {
                    writer.WriteLine($"pub struct C.{s.Name} {{}}");
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