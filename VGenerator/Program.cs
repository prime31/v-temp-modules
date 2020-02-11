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
				if (args.Length != 2)
				{
					Console.WriteLine("Invalid arguments. The -c option requires a filename");
					PrintHelp();
					return;
				}
				var index = Array.IndexOf(args, "-c");
				var file = args[index + 1];

				var options = new JsonSerializerOptions
				{
					WriteIndented = true
				};
				var json = JsonSerializer.Serialize(GetSDLConfig(), options);
				File.WriteAllText(file, json);
			}
			else if (args.Contains("-g"))
			{
				Console.WriteLine("Invalid arguments. The -g option requires a filename");
				if (args.Length != 2)
				{
					PrintHelp();
					return;
				}
				var index = Array.IndexOf(args, "-g");
				var file = args[index + 1];

				var config = JsonSerializer.Deserialize<Config>(File.ReadAllText(file));
				Run(config);
			}
			else
			{
				PrintHelp();

				Run(GetImGuiConfig());
				// Run(GetKincConfig());
				// Run(GetPhyFSConfig());
				// Run(GetSDLConfig());
				// Run(GetLuaConfig());
				// Run(GetFlecsConfig());
			}
		}

		private static void PrintHelp()
		{
			Console.WriteLine("VGenerator Help");
			Console.WriteLine("Standard usage pattern is to first use the '-c' option to create a template generator JSON file.");
			Console.WriteLine("The generator JSON file will have SDL2 data in it as an example so that you can see what the params look like.");
			Console.WriteLine("Fill in the details of the JSON file then use the '-g' option to generate the V bindings.");
			Console.WriteLine("\nUsage:");
			Console.WriteLine("\tWrite an empty generator configuration json file:");
			Console.WriteLine("\tVGenerator -c FILENAME");
			Console.WriteLine("\n\tGenerate V bindings from a generator configuration json file:");
			Console.WriteLine("\tVGenerator -g CONFIG_FILENAME");
		}

		static void Run(Config config)
		{
			var compilation = CppParser.ParseFiles(config.GetFiles(), config.ToParserOptions());
			VGenerator.Generate(config, compilation);
			// compilation.Dump();
		}

		static Config GetImGuiConfig()
		{
			return new Config
			{
				DstDir = "~/Desktop/imgui",
				SrcDir = "~/Desktop/lua-5.3.5/src",
				BaseSourceFolder = "src",
				ModuleName = "imgui",
				VWrapperFileName = "imgui",
				SingleVFileExport = true,
				ExcludeFunctionsThatContain = new string[] {},
				StripPrefixFromFunctionNames = new string[] { "ig"},
				CTypeToVType = {},
				Defines = new string[] {},
				IncludeFolders = new string[] {
					"/Users/desaro/.vmodules/via/libs/imgui/cimgui_git/imgui",
					"/Users/desaro/.vmodules/via/libs/imgui/cimgui_git"
				},
				Files = new string[] { "imgui.h", "cimgui.h" },
				ExcludedFiles = new string[] {},
				ExcludedFromVWrapperFiles = new string[] {}
			};
		}

		static Config GetLuaConfig()
		{
			return new Config
			{
				DstDir = "~/Desktop/lua",
				SrcDir = "~/Desktop/lua-5.3.5/src",
				BaseSourceFolder = "src",
				ModuleName = "lua",
				VWrapperFileName = "lua",
				SingleVFileExport = true,
				ExcludeFunctionsThatContain = new string[] {},
				StripPrefixFromFunctionNames = new string[] {},
				CTypeToVType = {
					{"__sFILE", "voidptr"}
				},
				Defines = new string[] {},
				IncludeFolders = new string[] { "src" },
				Files = new string[] {
					"lua.h", "lualib.h", "lauxlib.h"
				},
				ExcludedFiles = new string[] {},
				ExcludedFromVWrapperFiles = new string[] {}
			};
		}

		static Config GetFlecsConfig()
		{
			return new Config
			{
				DstDir = "~/Desktop/flecs/flecs",
				SrcDir = "/Users/desaro/.vmodules/prime31/flecs/flecs_git/src",
				BaseSourceFolder = "src",
				ModuleName = "flecs",
				VWrapperFileName = "flecs",
				SingleVFileExport = false,
				ExcludeFunctionsThatContain = new string[] {},
				StripPrefixFromFunctionNames = new string[] {},
				CTypeToVType = {},
				Defines = new string[] { "FLECS_NO_CPP" },
				IncludeFolders = new string[] {
					"/Users/desaro/.vmodules/prime31/flecs/flecs_git/include",
					"/Users/desaro/.vmodules/prime31/flecs/flecs_git/include/flecs",
					"/Users/desaro/.vmodules/prime31/flecs/flecs_git/include/flecs/util"
				},
				Files = new string[] {
					"flecs.h"
				},
				ExcludedFiles = new string[] {},
				ExcludedFromVWrapperFiles = new string[] {}
			};
		}

		static Config GetSDLConfig()
		{
			return new Config
			{
				DstDir = "~/Desktop/SDL2/sdl",
				SrcDir = "/usr/local/include/SDL2",
				BaseSourceFolder = "src",
				ModuleName = "sdl",
				VWrapperFileName = "sdl",
				SingleVFileExport = true,
				ExcludeFunctionsThatContain = new string[] {},
				StripPrefixFromFunctionNames = new string[] { "SDL_"},
				CTypeToVType = {
					{"__sFILE", "voidptr"}
				},
				Defines = new string[] {},
				IncludeFolders = new string[] {},
				Files = new string[] {
					"SDL.h"
				},
				ExcludedFiles = new string[] {
					"SDL_main", "SDL_audio", "SDL_assert", "SDL_atomic", "SDL_mutex",
					"SDL_thread", "SDL_gesture", "SDL_sensor", "SDL_power", "SDL_render", "SDL_shape",
					"SDL_endian", "SDL_cpuinfo", "SDL_loadso", "SDL_system"
				},
				ExcludedFromVWrapperFiles = new string[] {
					"SDL_stdinc"
				}
			};
		}

		static Config GetPhyFSConfig()
		{
			return new Config
			{
				DstDir = "/Users/desaro/Desktop/PhysFSGen",
				SrcDir = "/Users/desaro/Desktop/physfs/src",
				BaseSourceFolder = "src",
				ModuleName = "c",
				VWrapperFileName = "physfs",
				SingleVFileExport = true,
				ExcludeFunctionsThatContain = new string[] {},
				StripPrefixFromFunctionNames = new string[] { "PHYSFS_"},
				CTypeToVType = {},
				TargetSystem = "darwin",
				Defines = new string[] {},
				IncludeFolders = new string[] {},
				Files = new string[] {
					"physfs.h"
				}
			};
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
					"kinc/graphics1/graphics.h",

					"kinc/graphics4/constantlocation.h",
					"kinc/graphics4/graphics.h",
					"kinc/graphics4/indexbuffer.h",
					// "kinc/graphics4/pipeline.h",
					"kinc/graphics4/rendertarget.h",
					"kinc/graphics4/shader.h",
					"kinc/graphics4/texture.h",
					"kinc/graphics4/texturearray.h",
					"kinc/graphics4/textureunit.h",
					// "kinc/graphics4/vertexbuffer.h",
					// "kinc/graphics4/vertexstructure.h",

					"kinc/graphics5/commandlist.h",
					"kinc/graphics5/constantbuffer.h",

					"kinc/input/gamepad.h",
					"kinc/input/keyboard.h",
					"kinc/input/mouse.h",
					"kinc/input/surface.h",

					"kinc/io/filereader.h",
					"kinc/io/filewriter.h",

					// "kinc/math/matrix.h",
					"kinc/math/random.h",
					// "kinc/math/vector.h",

					"kinc/system.h",
					// "kinc/image.h",
					"kinc/window.h"
				}
			};
		}
	}
}
