using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

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
            foreach (var c in types.Consts)
            {
                // Console.WriteLine($"skipping const: {c.Name}");
                // writer.WriteLine($"\t{c.Name} = {c.Value}");
            }
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

            foreach (var e in types.Enums)
            {
                if (e.HasNegativeValues)
                {
                    Console.WriteLine($"skipping enum: {e.Name}");
                    continue;
                }

                // we strip this prefix from the enum values
                var enumPrefix = e.Name + "_";
                if (e.Name == "FMOD_RESULT")
                    enumPrefix = "FMOD_";
                
                e.Name = e.Name.Replace("FMOD_", "");
                e.Name = e.Name[0] + e.Name.Substring(1).ToLower();

                writer.WriteLine($"enum {e.Name} {{");
                foreach (var name in e.Enums)
                {
                    var newName = EscapeReservedWords(name.Replace(enumPrefix, "").ToLower());
                    if (char.IsDigit(newName[0]))
                        newName = "_" + newName;
                    writer.WriteLine($"\t{newName}");
                }
                writer.WriteLine("}");
                writer.WriteLine();
            }
        }

		static string EscapeReservedWords(string name)
		{
			if (name == "map")
				return "map";
			if (name == "string")
				return "str";
            if (name == "type")
                return "typ";
            if (name == "none")
                return "non";
			return name;
		}
    }
}