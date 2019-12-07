using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace Generator
{
	public class Specification
	{
		#region Helper Classes

		public class Enum
		{
			public string Name, Value, Api, Group;
		}

		public class Group
		{
			public string Name;
			public string[] Enums;
		}

		public class Feature
		{
			public string Name, Api;
			public Version Version;
			public string[] Enums;
			public string[] Commands;

			public bool HasCommand(string command) => Commands.Contains(command);

			public bool HasEnum(string enu) => Enums.Contains(enu);
		}

		public class AddRem
		{
			public string Profile;
			public List<string> AddedCommands = new List<string>();
			public List<string> RemovedCommands = new List<string>();
			public List<string> AddedEnums = new List<string>();
			public List<string> RemovedEnums = new List<string>();
		}

		public class Command
		{
			public string Name, Ret, Group;
			public Parameter[] Parameters;
		}

		public class Parameter
		{
			public string Name, Type, Group, Len;
		}

		#endregion

		public Group[] Groups;
		public Enum[] Enums;
		public Feature[] Features;
		public Command[] Commands;

		public Enum GetEnum(string name) => Enums.Where(e => e.Name == name).First();
		public Command GetCommand(string name) => Commands.Where(e => e.Name == name).First();
		public Group GetGroupForEnum(string enu) => Groups.Where(g => g.Enums.Contains(enu)).FirstOrDefault();

		public Specification(string file, string api, Version ver)
		{
			var xml = XElement.Load(file);

			Groups = ParseGroups(xml);
			Enums = ParseEnums(xml);
			Features = ParseFeatures(xml, api, ver);
			Commands = ParseCommands(xml);
		}

		Group[] ParseGroups(XElement xml)
		{
			var groups = new List<Group>();
			foreach (var xGroup in xml.Descendants("group"))
			{
				var group = new Group
				{
					Name = (string)xGroup.Attribute("name"),
					Enums = xGroup.Descendants("enum").Select(x => (string)x.Attribute("name")).ToArray()
				};
				groups.Add(group);
			}

			return groups.ToArray();
		}

		Enum[] ParseEnums(XElement xml)
		{
			var allEnums = new List<Enum>();

			foreach (var xEnums in xml.Descendants("enums"))
			{
				var group = (string)xEnums.Attribute("group");

				var tmpEnums = xEnums.Descendants("enum").Select(x => new Enum
				{
					Name = (string)x.Attribute("name"),
					Value = (string)x.Attribute("value"),
					Api = (string)x.Attribute("api"),
					Group = (string)group
				});
                allEnums.AddRange(tmpEnums);
			}

			return allEnums.ToArray();
		}

		Feature[] ParseFeatures(XElement xml, string requestedApi, Version requestedVersion)
		{
			var features = new List<Feature>();
			foreach (var xFeature in xml.Descendants("feature"))
			{
                var api = (string)xFeature.Attribute("api");
                var version = new Version((string)xFeature.Attribute("number"));
                if (api != requestedApi || version.CompareTo(requestedVersion) > 0)
                    continue;

				var feature = new Feature
				{
					Name = (string)xFeature.Attribute("name"),
					Api = api,
					Version = version
				};

                var addRem = new AddRem();
				foreach (var xRequire in xFeature.Descendants("require"))
				{
					// anything with a comment is EXT or not core spec material
					if (xRequire.Attribute("comment") != null)
						continue;

					addRem.AddedCommands
						.AddRange(xRequire.Descendants("command").Select(x => (string)x.Attribute("name")));
					addRem.AddedEnums
						.AddRange(xRequire.Descendants("enum").Select(x => (string)x.Attribute("name")));
				}

				foreach (var xRemove in xFeature.Descendants("remove"))
				{
					addRem.Profile = (string)xRemove.Attribute("profile");
					addRem.RemovedCommands
						.AddRange(xRemove.Descendants("command").Select(x => (string)x.Attribute("name")));
					addRem.RemovedEnums
						.AddRange(xRemove.Descendants("enum").Select(x => (string)x.Attribute("name")));
				}

                feature.Enums = addRem.AddedEnums.Where(e => !addRem.RemovedEnums.Contains(e)).ToArray();
                feature.Commands = addRem.AddedCommands.Where(e => !addRem.RemovedCommands.Contains(e)).ToArray();

				features.Add(feature);
			}

			return features.ToArray();
		}

		Command[] ParseCommands(XElement xml)
		{
			var commands = new List<Command>();
			foreach (var xCommand in xml.Descendants("commands").Descendants("command"))
			{
				var command = new Command();
				var xProto = xCommand.Element("proto");
				var xName = xProto.Element("name");

				command.Name = xName.Value;
				command.Ret = InnerXml(xProto).Replace(xName.ToString(), "")
                    .Replace("const", "").Replace("<ptype>", "").Replace("</ptype>", "").Replace(" ", "").Trim();
                if (command.Ret == "void")
                    command.Ret = "";

				var parameters = new List<Parameter>();
				foreach (var xParam in xCommand.Descendants("param"))
				{
					var rawType = InnerXml(xParam).Replace(xParam.Element("name").ToString(), "")
						.Replace("const", "").Replace("<ptype>", "").Replace("</ptype>", "").Replace(" ", "");

					var p = new Parameter
					{
						Group = (string)xParam.Attribute("group"),
						Len = (string)xParam.Attribute("len"),
						Type = rawType,
						Name = xParam.Element("name").Value
					};

                    if (p.Name == "type")
                        p.Name = "typ";
					parameters.Add(p);
				}
				command.Parameters = parameters.ToArray();

				commands.Add(command);
			}

			return commands.ToArray();
		}


		string InnerXml(XElement element)
		{
			var innerXml = new StringBuilder();
			foreach (XNode node in element.Nodes())
			{
				// append node's xml string to innerXml
				innerXml.Append(node.ToString());
			}

			return innerXml.ToString();
		}
	}
}