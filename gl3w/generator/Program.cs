﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Octokit;

namespace Generator
{
	class Program
	{
		static string[] UncompileableFunctions = new string[] {};

		static string[] MethodsWithRefParam = new string[] { "glDeleteBuffers" };

		static string RootDir
		{
			get
			{
				var dllPath = System.Reflection.Assembly.GetAssembly(typeof(Program)).Location;
				return Directory.GetParent(Path.GetDirectoryName(dllPath)).Parent.Parent.FullName;
			}
		}

		static void Main(string[] args)
		{
			if (args.Length == 0)
			{
				PrintHelp();
				return;
			}

			if (args.Contains("download"))
				DownloadXml();

			if (args.Contains("generate"))
				ParseArgsAndGenerateCode(args);
		}

		static void PrintHelp()
		{
			Console.WriteLine("--------------");
			Console.WriteLine("Valid options:");
			Console.WriteLine("download: downloads all specs and docs from Kronos. Must be run before generate");
			Console.WriteLine("generate: generates the V GL code");
			Console.WriteLine("generate options:");
			Console.WriteLine("\t-api=API");
			Console.WriteLine("\t-version=VERSION");
			Console.WriteLine("\t-profile=PROFILE");
			Console.WriteLine();
			Console.WriteLine("Example: 'generate -api=gl -version=3.3 -profile=core'");
			Console.WriteLine();
			Console.WriteLine("api: One of gl, gles1, gles2, egl, wgl, or glx");
			Console.WriteLine("version: The API version to generate. The 'all' pseudo-version includes all functions and enumerations for the specified API.");
			Console.WriteLine("profile: For gl packages with version 3.2 or higher, core or compatibility");
		}

		static void DownloadXml()
		{
			var rootDir = RootDir;
			var xmlDir = Path.Combine(rootDir, "xml");

			var docDir = Path.Combine(xmlDir, "doc");
			Directory.CreateDirectory(docDir);

			var specDir = Path.Combine(xmlDir, "spec");
			Directory.CreateDirectory(specDir);

			Console.WriteLine("Enter your GitHub username: ");
      		var user = Console.ReadLine();
			Console.WriteLine("Enter your GitHub password: ");
      		var pass = Console.ReadLine();

			var github = new GitHubClient(new ProductHeaderValue("gl-spec-downloader"));
			github.Credentials = new Credentials(user, pass);

			// fetch specs
			var searchResult = github.Repository.Content.GetAllContents("KhronosGroup", "EGL-Registry", "api").Result;
			Parallel.ForEach(searchResult, res =>
			{
				if (Regex.IsMatch(res.Name, @"^(egl)\.xml$"))
				{
					Console.WriteLine(res.DownloadUrl);
					DownloadFile(res.DownloadUrl, Path.Combine(specDir, res.Name));
				}
			});

			searchResult = github.Repository.Content.GetAllContents("KhronosGroup", "OpenGL-Registry", "xml").Result;
			Parallel.ForEach(searchResult, res =>
			{
				if (Regex.IsMatch(res.Name, @"^(gl|glx|wgl)\.xml$"))
				{
					Console.WriteLine(res.DownloadUrl);
					DownloadFile(res.DownloadUrl, Path.Combine(specDir, res.Name));
				}
			});

			// fetch docs
			var docRepoFolders = new[] { "es1.1", "es2.0", "es3.0", "es3.1", "es3", "gl2.1", "gl4" };
			foreach (var folder in docRepoFolders)
			{
				searchResult = github.Repository.Content.GetAllContents("KhronosGroup", "OpenGL-Refpages", folder).Result;
				Parallel.ForEach(searchResult, res =>
				{
					if (Regex.IsMatch(res.Name, @"^[ew]?gl[^u_].*\.xml$"))
					{
						Console.WriteLine(res.DownloadUrl);
						DownloadFile(res.DownloadUrl, Path.Combine(docDir, res.Name));
					}
				});
			}
		}

		static void DownloadFile(string url, string filename)
		{
			if (File.Exists(filename))
			{
				Console.WriteLine("File already downloaded. Skipping.");
				return;
			}

			using (var myWebClient = new WebClient())
				myWebClient.DownloadFile(url, filename);
		}

		static void ParseArgsAndGenerateCode(string[] args)
		{
			string api = null;
			string ver = null;
			string profile = null;
			for (var i = 1; i < args.Length; i++)
			{
				var arg = args[i];
				if (arg.StartsWith("-api"))
				{
					api = arg.Substring(5);
				}
				else if (arg.StartsWith("-version"))
				{
					ver = arg.Substring(9);
				}
				else if (arg.StartsWith("-profile"))
				{
					profile = arg.Substring(9);
				}
			}

			if (api == null || ver == null || profile == null)
			{
				Console.WriteLine("Error: one of -api, -version or -profile was not included in the arguments");
				return;
			}

			var folder = "gl" + ver.Replace(".", "");
			var outputFolder = Path.GetFullPath(Path.Combine(RootDir, "../", folder));
			Directory.CreateDirectory(outputFolder);

			// extensions can be either the full extension name or the 3-5 letter extension type (ARB, EXT, KHR, INTEL, etc)
			var extensions = new string[] { "GL_ARB_vertex_array_object", "GL_ARB_pixel_buffer_object", "GL_ARB_framebuffer_object", "GL_ARB_uniform_buffer_object" };
			PrepareSpecsAndGenerateCode(api, new Version(ver), profile, Path.Combine(RootDir, "xml"), outputFolder, extensions);
		}

		static void PrepareSpecsAndGenerateCode(string api, Version ver, string profile, string xmlDir, string outDir, string[] extensions)
		{
			var spec = ParseSpec(xmlDir, api, ver, extensions);
			var docs = new Documentation(Path.Combine(xmlDir, "doc"));
			var versionString = ver.ToString().Replace(".", "");

			foreach (var feature in spec.Features)
			{
				// actually generate the file here
				GenerateCode(spec, feature, docs, versionString, outDir);
			}

			GenerateEnums(spec, versionString, outDir);
		}

		static void GenerateCode(Specification spec, Specification.Feature feature, Documentation docs, string versionString, string outDir)
		{
			// if we want one module per version the module would need the version name
			var moduleDecl = $"module gl{versionString}";

			var baseName = feature.Version.Major > 0 ? feature.Version.ToString().Replace(".", "") : "ext";
			var filename = "gl" + baseName + "_c.v";
			var writer = new StreamWriter(File.Open(Path.Combine(outDir, filename), System.IO.FileMode.Create));

			var vFilename = "gl" + baseName + ".v";
			var vWriter = new StreamWriter(File.Open(Path.Combine(outDir, vFilename), System.IO.FileMode.Create));

			writer.WriteLine(moduleDecl); writer.WriteLine();
			vWriter.WriteLine(moduleDecl); vWriter.WriteLine();

			var groupedEnums = new List<Specification.Enum>();

			// Extensions all always have groups so no need to make the unnamed group for them
			if (!(feature is Specification.EXTFeature))
				writer.WriteLine("pub const (");
			foreach (var e in feature.Enums)
			{
				var en = spec.GetEnum(e);
				if (!string.IsNullOrEmpty(en.Group))
				{
					groupedEnums.Add(en);
					continue;
				}
				writer.WriteLine($"\t{en.Name} = {en.Value}");
			}
			if (!(feature is Specification.EXTFeature))
				writer.WriteLine(")");

			// dont think we need consts declared now that we have proper enums
			// var t = groupedEnums.GroupBy(e => e.Group, e => e, (g, all) => new { Group = g, Enums = all.ToArray() });
			// foreach (var grouping in t)
			// {
			// 	writer.WriteLine();
			// 	writer.WriteLine($"// {grouping.Group}");
			// 	writer.WriteLine("pub const (");

			// 	foreach (var e in grouping.Enums)
			// 		writer.WriteLine($"\t{e.Name} = {e.Value}");

			// 	writer.WriteLine(")");

			// 	Console.WriteLine($"Grouped: {grouping.Group}");
			// }

			writer.WriteLine(); writer.WriteLine();


			// function declarations
			string currentCommandGroup = null;
			foreach (var com in feature.Commands.Select(c => spec.GetCommand(c)))
			{
				if (UncompileableFunctions.Contains(com.Name))
				{
					Console.WriteLine($"Skipping {com.Name}");
					continue;
				}

				var newCommandGroup = (feature as Specification.EXTFeature)?.GetGroupForCommand(com.Name).Name;
				if (newCommandGroup != null && currentCommandGroup != newCommandGroup)
				{
					currentCommandGroup = newCommandGroup;
					writer.WriteLine();
					writer.WriteLine($"// OpenGL Extension: {currentCommandGroup}");
				}

				var ret = string.IsNullOrEmpty(com.Ret) ? "" : $" {Statics.GetVTypeForCType(com.Ret, true)}";
				var vRet = string.IsNullOrEmpty(com.Ret) ? "" : $" {Statics.GetVTypeForCType(com.Ret, true, true)}";
				if (com.Parameters.Length == 0)
				{
					writer.WriteLine($"fn C.{com.Name}(){ret}");

					vWriter.WriteLine($"pub fn {GlToSnakeCase(com.Name.Substring(2))}(){vRet} {{");
					vWriter.Write($"\t");
					if (vRet != "")
						vWriter.Write("return ");
					vWriter.Write($"C.{com.Name}()");
					vWriter.WriteLine();
					vWriter.WriteLine("}");
				}
				else
				{
					if (docs.TryGetValue(com.Name, out var d))
					{
						writer.WriteLine();
						writer.WriteLine($"// {d}");
					}

					writer.Write($"fn C.{com.Name}(");

					// we hand-write some methods that can be tricky and make the vWriter null for them
					var originalVWriter = vWriter;
					if (ManualTranslation.HasManualVImplementation(com.Name))
					{
						ManualTranslation.WriteVMethod(vWriter, com.Name);
						vWriter = StreamWriter.Null;
					}

					vWriter.Write($"pub fn {GlToSnakeCase(com.Name.Substring(2))}(");

					var vParams = new StringBuilder();
					for (var i = 0; i < com.Parameters.Length; i++)
					{
						var p = com.Parameters[i];
						var type = Statics.GetVTypeForCType(p.Type, false);
						var vType = Statics.GetVTypeForCType(p.Type, false, true);
						var vName = GlToSnakeCase(p.Name);
						if (!string.IsNullOrEmpty(p.Group) && spec.IsInNonEmptyGroup(p.Group))
							vType = p.Group;

						if (vType.Contains("[]") && (com.Name.StartsWith("glGet")
							|| MethodsWithRefParam.Contains(com.Name)) || com.Name.StartsWith("glUniform"))
							vType = vType.Replace("[]", "&");

						writer.Write($"{p.Name} {type}");
						vWriter.Write($"{vName} {vType}");

						if (vType.Contains("[]"))
							vParams.Append($"{vName}.data");
						else if (vType == "string")
							vParams.Append($"{vName}.str");
						else
							vParams.Append(vName);

						if (i < com.Parameters.Length - 1)
						{
							writer.Write(", ");
							vWriter.Write(", ");
							vParams.Append(", ");
						}
					}

					writer.WriteLine($"){ret}");
					vWriter.WriteLine($"){vRet} {{");
					vWriter.Write($"\t");
					if (vRet != "")
						vWriter.Write("return ");

					// params to call C method (first, second, third)
					vWriter.Write($"C.{com.Name}(");
					vWriter.Write(vParams.ToString());
					vWriter.Write($")");

					vWriter.WriteLine();
					vWriter.WriteLine("}");

					// retore the vWriter in case it is nulled out
					vWriter = originalVWriter;
				}

				vWriter.WriteLine();
			}

			writer.Dispose();
			vWriter.Dispose();
		}

		static void GenerateEnums(Specification spec, string versionString, string outDir)
		{
			var filename = "enums.v";
			var writer = new StreamWriter(File.Open(Path.Combine(outDir, filename), System.IO.FileMode.Create));

			writer.WriteLine($"module gl{versionString}"); writer.WriteLine();

			foreach (var kvPair in spec.GroupedEnums)
			{
				writer.WriteLine($"pub enum {kvPair.Key} {{");

				var hasReservedWord = HasReservedWord(kvPair.Value);
				foreach (var e in kvPair.Value)
				{
					var name = e.Name.Replace("GL_", "").ToLower();
					if (hasReservedWord)
						name = "gl_" + name;
					if (char.IsDigit(name[0]))
						name = "gl_" + name;
					writer.WriteLine($"\t{name} = {e.Value}");
				}

				writer.WriteLine("}");
				writer.WriteLine();
			}

			writer.Dispose();
		}

		static string GlToSnakeCase(string name)
		{
			if (name.EndsWith("1D") || name.EndsWith("2D") || name.EndsWith("3D"))
				name = name.Substring(0, name.Length - 2) + "_" + name.Substring(name.Length - 2, 1) + char.ToLower(name[name.Length - 1]);
			name = string.Concat(name.Select((x, i) => i > 0 && char.IsUpper(x) ? "_" + x.ToString() : x.ToString())).ToLower();
			return EscapeReservedWords(name);
		}

		static string EscapeReservedWords(string name)
		{
			if (name == "map")
				return "map";
			if (name == "string")
				return "str";
			if (name == "return")
				return "ret";
			return name;
		}

		static bool HasReservedWord(List<Specification.Enum> enums)
		{
			var reserved = new [] {"map", "string", "return", "or", "none", "type", "select", "false", "true"};
			return enums.Where(e => reserved.Contains(e.Name.Replace("GL_", "").ToLower())).Count() > 0;
		}

		static Specification ParseSpec(string xmlDir, string api, Version ver, string[] extensions)
		{
			var specDir = Path.Combine(xmlDir, "spec");
			foreach (var file in Directory.GetFiles(specDir))
			{
				if (Path.GetFileNameWithoutExtension(file) == api)
					return new Specification(file, api, ver, extensions);
			}

			throw new Exception($"Invalid api {api}!");
		}
	}
}
