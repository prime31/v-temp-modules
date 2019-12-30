using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace Generator
{
    class Function
    {
        public string Name, VName, RetType;
        public List<Argument> Arguments = new List<Argument>();
        public bool IsYogaNodeRefMethod;

        public void Prepare()
        {
            if (Name.StartsWith("YGNode") && Arguments.Count > 0)
                IsYogaNodeRefMethod = Arguments[0].Type == "YGNodeRef" || Arguments[0].Type == "YGNodeConstRef";

            if (RetType == "void")
                RetType = "";
            else
                RetType = Program.VTypeForCType(RetType);
            
            VName = Name;
            if (IsYogaNodeRefMethod)
                VName = VName.Replace("YGNode", "");
            else
                VName = VName.Replace("YG", "");
            VName = Program.ToSnakeCase(VName);

            for (var i = 0; i < Arguments.Count; i++)
            {
                var arg = Arguments[i];
                var type = Program.VTypeForCType(arg.Type);
                var name = arg.Name;

                if (name.EndsWith("[]"))
                {
                    name = name.Replace("[]", "");
                    type = "[]" + type;
                }

                arg.Name = name;

                arg.VName = Program.ToSnakeCase(name);
                arg.Type = type;
            }
        }
    }

    class Argument
    {
        public string Name, VName, Type;
    }

    class Program
    {
        static List<Function> functions = new List<Function>();

        static Dictionary<string, string> CTypeToVType = new Dictionary<string, string>
        {
            {"float", "f32"},
            {"void*", "voidptr"},
            {"uint32_t", "u32"},
            {"int32_t", "int"},
            {"bool", "bool"},
            {"byteptr", "byteptr"},
            // callback with enum types cant be defined yet
            // {"YGLogger", "fn(config C.YGConfigRef, node C.YGNodeRef, level YGLogLevel, format byteptr) int"},
            {"YGLogger", "voidptr"},
            // {"YGMeasureFunc", "fn(node C.YGNodeRef, width f32, widthMode YGMeasureMode, height f32, heightMode YGMeasureMode) C.YGSize"},
            {"YGMeasureFunc", "voidptr"},
            {"YGNodeCleanupFunc", "fn(node YGNodeRef)"},
            {"YGCloneNodeFunc", "fn(oldNode C.YGNodeRef, owner C.YGNodeRef, childIndex int)"},
            {"YGNodeRef", "C.YGNodeRef"},
            {"YGNodeConstRef", "C.YGNodeConstRef"},
            {"YGConfigRef", "C.YGConfigRef"},
            {"YGSize", "C.YGSize"},
            {"YGValue", "C.YGValue"}
        };

        static HashSet<string> uniqueTypes = new HashSet<string>();

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
            Environment.CurrentDirectory = Path.Combine(RootDir, "yoga_git/yoga");
            var outFile = Path.Combine(RootDir, "c_funcs.v");
            var outVFile = Path.Combine(RootDir, "yoga.v");

            ParseFile(File.ReadAllLines("Yoga.h"));

            using (var writer = new StreamWriter(File.Open(outFile, System.IO.FileMode.Create)))
            {
                using (var vWriter = new StreamWriter(File.Open(outVFile, System.IO.FileMode.Create)))
                    WriteFile(writer, vWriter);
            }

            foreach (var t in uniqueTypes)
                Console.WriteLine(t);
        }

        static void ParseFile(string[] lines)
        {
            for (var i = 0; i < lines.Length; i++)
            {
                var line = lines[i];

                if (line.StartsWith("WIN_EXPORT"))
                {
                    // single line methods
                    if (line.EndsWith(";"))
                    {
                        ParseFunction(line);
                        continue;
                    }

                    var sb = new StringBuilder();
                    sb.Append(line.Trim());

                    do
                    {
                        line = lines[++i];
                        sb.Append(line.Trim());
                    }
                    while (!line.EndsWith(";"));
                    ParseFunction(sb.ToString());
                }
            }
        }

        static void ParseFunction(string func)
        {
            var function = new Function();
            functions.Add(function);

            func = func.Replace("WIN_EXPORT ", "").Replace(";", "");
            var retIndex = func.IndexOf(' ');

            function.RetType = func.Substring(0, retIndex);
            func = func.Substring(retIndex + 1);

            function.Name = func.Substring(0, func.IndexOf('('));
            func = func.Substring(func.IndexOf('(') + 1).Replace(")", "");

            // args
            if (func == "void")
                return;

            func = func.Replace("const char*", "byteptr").Replace("const ", "");
            var args = func.Split(',');
            foreach (var arg in args)
            {
                var argParts = arg.Split(' ', StringSplitOptions.RemoveEmptyEntries);
                var type = argParts[0].Trim();
                var name = argParts[1].Trim();
                function.Arguments.Add(new Argument
                {
                    Name = name,
                    Type = type
                });
            }
        }

        static void WriteFile(StreamWriter writer, StreamWriter vWriter)
        {
            vWriter.WriteLine("module yoga");
            vWriter.WriteLine();
            vWriter.WriteLine("pub struct C.YGNodeRef {}");
            vWriter.WriteLine();

            writer.WriteLine("module yoga");
            writer.WriteLine();

            foreach (var f in functions)
            {
                f.Prepare();
                if (f.IsYogaNodeRefMethod)
                    vWriter.Write("pub fn (n C.YGNodeRef) ");
                else
                    vWriter.Write("pub fn ");
                vWriter.Write($"{f.VName}(");

                writer.Write("fn C.");
                writer.Write($"{f.Name}(");

                var vMethodCallParams = new StringBuilder();

                for (var i = 0; i < f.Arguments.Count; i++)
                {
                    var arg = f.Arguments[i];
                    writer.Write($"{arg.Name} {arg.Type}");

                    // skip the first arg for YogaNodeRef methods
                    var vSkippedArg = true;
                    if (!f.IsYogaNodeRefMethod || i > 0)
                    {
                        vWriter.Write($"{arg.VName} {arg.Type}");
                        if (arg.Type.Contains("[]"))
                            vMethodCallParams.Append($"{arg.VName}.data");
                        else
                            vMethodCallParams.Append(arg.VName);
                        vSkippedArg = false;
                    }
                    else
                    {
                        // first param is n if this is a YogaNodeRef method
                        vMethodCallParams.Append("n");
                    }

                    if (i < f.Arguments.Count - 1)
                    {
                        writer.Write(", ");
                        vMethodCallParams.Append(", ");
                        if (!vSkippedArg)
                            vWriter.Write(", ");
                    }
                }

                writer.Write(")");
                vWriter.Write(")");

                if (f.RetType != "")
                {
                    writer.Write($" {f.RetType}");
                    vWriter.Write($" {f.RetType}");
                }
                vWriter.Write(" {");

                // now we call the C method in the V method
                vWriter.WriteLine();

                // HACK: comment out methods that dont compile/link
                if (f.Name == "YGNodePrint")
                {
                    vWriter.WriteLine("\tprintln('YGNodePrint doesnt compile for some reason...')");
                    vWriter.Write("//");
                }

                var ret = f.RetType != "" ? "return " : "";
                vWriter.Write($"\t{ret}C.{f.Name}({vMethodCallParams.ToString()})");
                vWriter.WriteLine();
                vWriter.WriteLine("}");
                vWriter.WriteLine();

                writer.WriteLine();
            }
        }

        public static string VTypeForCType(string type)
        {
            if (CTypeToVType.TryGetValue(type, out var newType))
                return newType;

            uniqueTypes.Add(type);

            return type;
        }

        public static string ToSnakeCase(string name)
		{
			if (name.EndsWith("1D") || name.EndsWith("2D") || name.EndsWith("3D"))
				name = name.Substring(0, name.Length - 2) + "_" + name.Substring(name.Length - 2, 1) + char.ToLower(name[name.Length - 1]);
			name = string.Concat(name.Select((x, i) => i > 0 && char.IsUpper(x) ? "_" + x.ToString() : x.ToString())).ToLower();
			
            if (name == "assert")
                name = "yg_" + name;
            return name;
		}
    }
}
