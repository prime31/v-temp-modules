using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using Octokit;

namespace generator
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
			var specs = ParseSpecs(xmlDir);
			var docs = new Documentation(Path.Combine(xmlDir, "doc"));

			foreach (var spec in specs)
			{
				if (SpecValid(spec, ver, api))
				{
					// Select the commands and enums relevant to the specified API version
					foreach (var feature in spec.Features.Where(f => FeatureValid(f, ver, api)))
					{
						if (AddRemValid(feature.AddRem, profile))
						{
							if (feature.AddRem.AddedCommands != null)
							foreach (var c in feature.AddRem.AddedCommands)
							{
								if (!feature.HasCommand(c))
									Console.WriteLine("wtf command");
							}

							if (feature.AddRem.AddedEnums != null)
							foreach (var e in feature.AddRem.AddedEnums)
							{
								if (!feature.HasEnum(e))
									Console.WriteLine("wtf enum");
							}

							if (feature.AddRem.RemovedCommands != null)
							foreach (var c in feature.AddRem.RemovedCommands)
							{
								if (feature.HasCommand(c))
									Console.WriteLine("wtf ftw command");
							}

							if (feature.AddRem.RemovedEnums != null)
							foreach (var e in feature.AddRem.RemovedEnums)
							{
								if (feature.HasEnum(e))
									Console.WriteLine("wtf ftw enum");
							}
						}

						// actually generate the file here
						GenerateCode(feature, ver);
					}
				}
			}
		}

		static void GenerateCode(Specification.Feature feature, Version version)
		{

		}

		static bool SpecValid(Specification specification, Version version, string api)
		{
			foreach (var feature in specification.Features)
			{
				if (feature.Api == api && feature.Version.CompareTo(version) < 0)
					return true;
			}

			return false;
		}

		static bool FeatureValid(Specification.Feature feature, Version version, string api)
		{
			if (feature.Api == api && feature.Version.CompareTo(version) < 0)
				return true;

			return false;
		}

		static bool AddRemValid(Specification.AddRem addRem, string profile)
		{
			if (addRem.Profile != profile && !string.IsNullOrEmpty(addRem.Profile))
				return false;

			return true;
		}

		static List<Specification> ParseSpecs(string xmlDir)
		{
			var specs = new List<Specification>();

			var specDir = Path.Combine(xmlDir, "spec");
			foreach (var file in Directory.GetFiles(specDir))
				specs.Add(new Specification(file));

			return specs;
		}
	}
}
