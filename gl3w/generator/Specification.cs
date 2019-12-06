using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace generator
{
	public class Specification
	{
        #region Helper Classes

		public class Enum
		{
			public string Name, Value, Api;
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
            public AddRem AddRem;

            public bool HasCommand(string command) => Commands.Contains(command);

            public bool HasEnum(string enu) => Enums.Contains(enu);
		}

        public class AddRem
        {
            public string Profile;
            public string[] AddedCommands;
            public string[] RemovedCommands;
            public string[] AddedEnums;
            public string[] RemovedEnums;
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

		public Specification(string file)
		{
			var xml = XElement.Load(file);

			Groups = ParseGroups(xml);
			Enums = ParseEnums(xml);
			Features = ParseFeatures(xml);
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
			var tmpEnums = xml.Descendants("enum").Select(x => new Enum
			{
				Name = (string)x.Attribute("name"),
				Value = (string)x.Attribute("value"),
				Api = (string)x.Attribute("api")
			});

			return tmpEnums.ToArray();
		}

		Feature[] ParseFeatures(XElement xml)
		{
			var features = new List<Feature>();
			foreach (var xFeature in xml.Descendants("feature"))
			{
				var feature = new Feature
				{
					Name = (string)xFeature.Attribute("name"),
					Api = (string)xFeature.Attribute("api"),
					Version = new Version((string)xFeature.Attribute("number")),
					Enums = xFeature.Descendants("enum").Select(x => (string)x.Attribute("name")).Distinct().ToArray(),
					Commands = xFeature.Descendants("command").Select(x => (string)x.Attribute("name")).Distinct().ToArray(),
                    AddRem = new AddRem()
				};

                foreach (var xRequire in xFeature.Descendants("require"))
                {
                    feature.AddRem.AddedCommands = xRequire.Descendants("command")
                        .Select(x => (string)x.Attribute("name")).ToArray();
                    feature.AddRem.AddedEnums = xRequire.Descendants("enum")
                        .Select(x => (string)x.Attribute("name")).ToArray();
                }

                foreach (var xRemove in xFeature.Descendants("remove"))
                {
                    feature.AddRem.Profile = (string)xRemove.Attribute("profile");
                    feature.AddRem.AddedCommands = xRemove.Descendants("command")
                        .Select(x => (string)x.Attribute("name")).ToArray();
                    feature.AddRem.AddedEnums = xRemove.Descendants("enum")
                        .Select(x => (string)x.Attribute("name")).ToArray();
                }
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
				command.Ret = InnerXml(xProto).Replace(xName.ToString(), "").Trim();

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