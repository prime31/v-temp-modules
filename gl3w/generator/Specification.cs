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
            public string[] Names;
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

        public class EXTFeature : Feature
        {
            public Group[] CommandGroup;

			public Group GetGroupForCommand(string name) => CommandGroup.Where(g => g.Names.Contains(name)).FirstOrDefault();
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
            public bool IsRetConst;
            public Parameter[] Parameters;
        }

        public class Parameter
        {
            public string Name, Type, Group, Len;
            public bool IsConst;
        }

        #endregion

        public Group[] Groups;
        public Enum[] Enums;
        public Feature[] Features;
        public Command[] Commands;

        public SortedDictionary<string, List<Enum>> GroupedEnums = new SortedDictionary<string, List<Enum>>();

        public Enum GetEnum(string name) => Enums.Where(e => e.Name == name).First();
        public Command GetCommand(string name) => Commands.Where(e => e.Name == name).First();
        public Group[] GetGroupsForEnum(string enu) => Groups.Where(g => g.Names.Contains(enu)).ToArray();
        public bool IsInNonEmptyGroup(string enu) => Groups.Where(g => g.Name == enu && g.Names.Length > 0).Count() > 0;

        bool HasEnum(string name) => Enums.Where(e => e.Name == name).FirstOrDefault() != null;
        bool HasCommand(string name) => Commands.Where(e => e.Name == name).FirstOrDefault() != null;

        public Specification(string file, string api, Version ver, string[] extensions)
        {
            var xml = XElement.Load(file);

            Groups = ParseGroups(xml);
            Enums = ParseEnums(xml);
            Commands = ParseCommands(xml);
            Features = ParseFeatures(xml, api, ver, extensions);

            // add groups for all enums that are missing them
            foreach (var e in Enums)
            {
                // no group. lets see if we can find one
                if (string.IsNullOrEmpty(e.Group))
                {
                    foreach (var g in GetGroupsForEnum(e.Name))
                        e.Group = g.Name;
                }
            }

            // create a global list of grouped enums used for writing out actual enums
            foreach (var e in Enums)
            {
                if (!string.IsNullOrEmpty(e.Group))
                {
                    foreach (var g in GetGroupsForEnum(e.Name))
                    {
                        if (!GroupedEnums.TryGetValue(g.Name, out var enumList))
                        {
                            enumList = new List<Enum>();
                            GroupedEnums[g.Name] = enumList;
                        }
                        enumList.Add(e);
                    }
                }
            }
        }

        Group[] ParseGroups(XElement xml)
        {
            var groups = new List<Group>();
            foreach (var xGroup in xml.Descendants("group"))
            {
                var group = new Group
                {
                    Name = (string)xGroup.Attribute("name"),
                    Names = xGroup.Descendants("enum").Select(x => (string)x.Attribute("name")).ToArray()
                };
                groups.Add(group);
				// Console.WriteLine($"{group.Name}: {group.Names.Length}");
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

        Feature[] ParseFeatures(XElement xml, string requestedApi, Version requestedVersion, string[] extensions)
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

                foreach (var f in features)
                {
                    f.Enums = f.Enums.Where(e => !addRem.RemovedEnums.Contains(e)).ToArray();
                    f.Commands = f.Commands.Where(e => !addRem.RemovedCommands.Contains(e)).ToArray();
                }

                features.Add(feature);
            }

            features.Add(HandleExtensions(xml, requestedApi, features, extensions));

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
                command.IsRetConst = xProto.Value.Contains("const");
                command.Ret = InnerXml(xProto).Replace(xName.ToString(), "")
                    .Replace("const", "").Replace("<ptype>", "").Replace("</ptype>", "").Replace(" ", "").Trim();
                if (command.Ret == "void")
                    command.Ret = "";

                var parameters = new List<Parameter>();
                foreach (var xParam in xCommand.Descendants("param"))
                {
                    var isConst = xParam.Value.Contains("const");
                    var rawType = InnerXml(xParam).Replace(xParam.Element("name").ToString(), "")
                        .Replace("const", "").Replace("<ptype>", "").Replace("</ptype>", "").Replace(" ", "");

                    var p = new Parameter
                    {
                        Group = (string)xParam.Attribute("group"),
                        Len = (string)xParam.Attribute("len"),
                        Type = rawType,
                        Name = xParam.Element("name").Value,
                        IsConst = isConst
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

        Feature HandleExtensions(XElement xml, string api, List<Feature> currentFeatures, string[] includedExtensions)
        {
			// includedExtensions can be either a full extension name or the shortcode
			Func<string, bool> isExtensionRequested = extensionName =>
			{
				foreach (var ext in includedExtensions)
				{
					if (extensionName == ext)
						return true;

					if (extensionName.StartsWith("GL_" + ext.ToUpper()))
						return true;
				}
				return false;
			};

            var enums = new List<string>();
            var commands = new List<string>();
            var commandGroups = new List<Group>();
            foreach (var xExtension in xml.Descendants("extensions").Descendants("extension"))
            {
                var supported = ((string)xExtension.Attribute("supported")).Split('|');
                if (!supported.Contains(api))
                    continue;

                var name = (string)xExtension.Attribute("name");
                if (!isExtensionRequested(name))
                    continue;

                foreach (var xRequire in xExtension.Descendants("require"))
                {
                    var c = xRequire.Descendants("command").Select(x => (string)x.Attribute("name"));
                    commands.AddRange(c);
                    commandGroups.Add(new Group
                    {
                        Name = name,
                        Names = c.ToArray()
                    });

                    var e = xRequire.Descendants("enum").Select(x => (string)x.Attribute("name"));
                    enums.AddRange(e);

					foreach (var enumName in e)
					{
						var actualEnum = GetEnum(enumName);
						actualEnum.Group = name;
					}
                }
            }

            // only add those that arent already defined elsewhere
            foreach (var f in currentFeatures)
            {
                enums.RemoveAll(e => f.Enums.Contains(e));
                commands.RemoveAll(c => f.Commands.Contains(c));
            }

            var feature = new EXTFeature
            {
                Name = "Extensions",
                Api = "EXT",
                Version = new Version(0, 0),
                Commands = commands.ToArray(),
				Enums = enums.ToArray(),
				CommandGroup = commandGroups.ToArray()
            };
            return feature;
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