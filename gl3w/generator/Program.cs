using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using Octokit;

namespace Generator
{
	class Program
	{
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
			foreach (var res in searchResult)
			{
				if (Regex.IsMatch(res.Name, @"^(egl)\.xml$"))
				{
					Console.WriteLine(res.DownloadUrl);
					DownloadFile(res.DownloadUrl, Path.Combine(specDir, res.Name));
				}
			}

			searchResult = github.Repository.Content.GetAllContents("KhronosGroup", "OpenGL-Registry", "xml").Result;
			foreach (var res in searchResult)
			{
				if (Regex.IsMatch(res.Name, @"^(gl|glx|wgl)\.xml$"))
				{
					Console.WriteLine(res.DownloadUrl);
					DownloadFile(res.DownloadUrl, Path.Combine(specDir, res.Name));
				}
			}

			// fetch docs
			var docRepoFolders = new[] { "es1.1", "es2.0", "es3.0", "es3.1", "es3", "gl2.1", "gl4" };
			foreach (var folder in docRepoFolders)
			{
				searchResult = github.Repository.Content.GetAllContents("KhronosGroup", "OpenGL-Refpages", folder).Result;
				foreach (var res in searchResult)
				{
					if (Regex.IsMatch(res.Name, @"^[ew]?gl[^u_].*\.xml$"))
					{
						Console.WriteLine(res.DownloadUrl);
						DownloadFile(res.DownloadUrl, Path.Combine(docDir, res.Name));
					}
				}
			}
		}

		static void DownloadFile(string url, string filename)
		{
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

			PrepareSpecsAndGenerateCode(api, new Version(ver), profile, Path.Combine(RootDir, "xml"), Path.GetFullPath(Path.Combine(RootDir, "../")));
		}

		static void PrepareSpecsAndGenerateCode(string api, Version ver, string profile, string xmlDir, string outDir)
		{
			var spec = ParseSpec(xmlDir, api, ver);
			// TODO: add docs
			//var docs = new Documentation(Path.Combine(xmlDir, "doc"));

			// Select the commands and enums relevant to the specified API version
			foreach (var feature in spec.Features)
			{
				// actually generate the file here
				GenerateCode(spec, feature, ver, outDir);
			}
		}

		static void GenerateCode(Specification spec, Specification.Feature feature, Version version, string outDir)
		{
			// if we want one module per version the module would need the version name
			//var moduleDecl = $"module gl" + feature.Version.ToString().Replace(".", "");
			var moduleDecl = "module gl3w";

			var filename = "gl" + feature.Version.ToString().Replace(".", "") + ".v";
			var stream = File.Open(Path.Combine(outDir, filename), System.IO.FileMode.Create);
			var writer = new StreamWriter(stream);

			writer.WriteLine(moduleDecl);
			writer.WriteLine();

			var groupedEnums = new List<Specification.Enum>();
			writer.WriteLine("const (");
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
			writer.WriteLine(")");

			var t = groupedEnums.GroupBy(e => e.Group, e => e, (g, all) => new { Group = g, Enums = all.ToArray() });
			foreach (var grouping in t)
			{
				writer.WriteLine();
				writer.WriteLine($"// {grouping.Group}");
				writer.WriteLine("const (");

				foreach (var e in grouping.Enums)
					writer.WriteLine($"\t{e.Name} = {e.Value}");

				writer.WriteLine(")");
			}

			writer.WriteLine(); writer.WriteLine();


			// function declarations
			foreach (var c in feature.Commands.Select(c => spec.GetCommand(c)))
			{
				var ret = string.IsNullOrEmpty(c.Ret) ? "" : $" {Statics.GetVTypeForCType(c.Ret, true)}";
				if (c.Parameters.Length == 0)
				{
					writer.WriteLine($"fn C.{c.Name}(){ret}");
				}
				else
				{
					writer.Write($"fn C.{c.Name}(");

					for (var i = 0; i < c.Parameters.Length; i++)
					{
						var p = c.Parameters[i];
						var type = Statics.GetVTypeForCType(p.Type, false);
						writer.Write($"{p.Name} {type}");

						if (i < c.Parameters.Length - 1)
							writer.Write(", ");
					}

					writer.WriteLine($"){ret}");
				}
			}

			writer.Dispose();
		}

		static Specification ParseSpec(string xmlDir, string api, Version ver)
		{
			var specDir = Path.Combine(xmlDir, "spec");
			foreach (var file in Directory.GetFiles(specDir))
			{
				if (Path.GetFileNameWithoutExtension(file) == api)
					return new Specification(file, api, ver);
			}

			throw new Exception($"Invalid api {api}!");
		}
	}
}
