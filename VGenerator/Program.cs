using System;
using System.Linq;
using CppAst;
using System.Text.Json;
using System.IO;

namespace Generator
{
	class Program
	{
		static void Main(string[] args)
		{
			if (args.Contains("-h"))
			{
				PrintHelp();
			}
			else if (args.Contains("-c"))
			{
				var index = Array.IndexOf(args, "-c");
				var file = args[index + 1];

				var options = new JsonSerializerOptions
				{
					WriteIndented = true
				};
				var json = JsonSerializer.Serialize(GetKincConfig(), options);
				File.WriteAllText(file, json);
			}
			else if (args.Contains("-g"))
			{
				var index = Array.IndexOf(args, "-g");
				var file = args[index + 1];

				var config = JsonSerializer.Deserialize<Config>(File.ReadAllText(file));
				Run(config);
			}
			else
			{
				Run(GetKincConfig());
			}
		}

		private static void PrintHelp()
		{
			Console.WriteLine("-c FILE");
			Console.WriteLine("-g FILE");
		}

		static void Run(Config config)
		{
			var compilation = CppParser.ParseFiles(config.GetFiles(), config.ToParserOptions());
			VGenerator.Generate(config, compilation);
			compilation.Dump();
		}

		static Config GetKincConfig()
		{
			return new Config
			{
				DstDir = "/Users/desaro/Desktop/KincGen",
				SrcDir = "/Users/desaro/Desktop/kha/Shader-Kinc/Kinc",
				BaseSourceFolder = "kinc",
				ModuleName = "c",
				SingleVFileExport = true,
				ExcludeFunctionsThatContain = new string[] { "_internal_" },
				StripPrefixFromFunctionNames = new string[] { "kinc_g4_", "kinc_g5_", "kinc_", "LZ4_" },
				CTypeToVType = {
					{"kinc_ticks_t", "u64"},
					{"id", "voidptr"}
				},
				TargetSystem = "darwin",
				Defines = new string[] {
					"KORE_MACOS", "KORE_METAL", "KORE_POSIX", "KORE_G1", "KORE_G2", "KORE_G3", "KORE_G4",
					"KORE_G5", "KORE_G4ONG5", "KORE_MACOS", "KORE_METAL", "KORE_POSIX", "KORE_A1", "KORE_A2",
					"KORE_A3", "KORE_NO_MAIN"
				},
				IncludeFolders = new string[] {
					"Sources",
					"Backends/System/Apple/Sources",
					"Backends/System/macOS/Sources",
					"Backends/System/POSIX/Sources",
					"Backends/Graphics5/Metal/Sources",
					"Backends/Graphics4/G4onG5/Sources",
					"Backends/Audio3/A3onA2/Sources"
				},
				Files = new string[] {
					"Sources/kinc/graphics1/graphics.h",

					"Sources/kinc/graphics4/constantlocation.h",
					"Sources/kinc/graphics4/graphics.h",
					"Sources/kinc/graphics4/indexbuffer.h",
					// "Sources/kinc/graphics4/pipeline.h",
					"Sources/kinc/graphics4/rendertarget.h",
					"Sources/kinc/graphics4/shader.h",
					"Sources/kinc/graphics4/texture.h",
					"Sources/kinc/graphics4/texturearray.h",
					"Sources/kinc/graphics4/textureunit.h",
					// "Sources/kinc/graphics4/vertexbuffer.h",
					// "Sources/kinc/graphics4/vertexstructure.h",

					"Sources/kinc/graphics5/commandlist.h",
					"Sources/kinc/graphics5/constantbuffer.h",

					"Sources/kinc/input/gamepad.h",
					"Sources/kinc/input/keyboard.h",
					"Sources/kinc/input/mouse.h",
					"Sources/kinc/input/surface.h",

					"Sources/kinc/io/filereader.h",
					"Sources/kinc/io/filewriter.h",

					// "Sources/kinc/math/matrix.h",
					"Sources/kinc/math/random.h",
					// "Sources/kinc/math/vector.h",

					"Sources/kinc/system.h",
					// "Sources/kinc/image.h",
					"Sources/kinc/window.h"
				}
			};
		}
	}
}
