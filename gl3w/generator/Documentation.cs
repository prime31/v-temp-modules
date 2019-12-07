using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace Generator
{
	public class Documentation : Dictionary<string, string>
	{
		public Documentation(string docDir)
		{
			foreach (var file in Directory.GetFiles(docDir))
				ParseDoc(file);
		}

		void ParseDoc(string file)
		{
			var first = 0;
			var sb = new StringBuilder();
			var ms = new MemoryStream();
			var writer = new StreamWriter(ms);

			// hack up the xml to get just what we want since it isnt valid
			writer.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
			writer.WriteLine("<root>");

			var lines = File.ReadAllLines(file);
			for (var i = 0; i < lines.Length; i++)
			{
				if (first == 0 && lines[i].Contains("<refnamediv"))
				{
					first = i;
					writer.WriteLine(lines[i]);
					continue;
				}

				if (lines[i].Contains("</refnamediv>"))
				{
					writer.WriteLine(lines[i]);
					break;
				}

				if (first > 0)
					writer.WriteLine(lines[i]);
			}

			writer.WriteLine("</root>");
			writer.Flush();
			ms.Seek(0, SeekOrigin.Begin);

			try
			{
				var xml = XElement.Load(ms);
				var xDiv = xml.Descendants("refnamediv").First();
				var purpose = xDiv.Element("refpurpose").Value;

				foreach (var xName in xDiv.Descendants("refname"))
				{
					this[xName.Value] = purpose;
				}
			}
			catch (Exception e)
			{
                Console.WriteLine("bad xml: " + file);
				Console.WriteLine(e);
			}

			writer.Dispose();
			ms.Dispose();
		}
	}
}