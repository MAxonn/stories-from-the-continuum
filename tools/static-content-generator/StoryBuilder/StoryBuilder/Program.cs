using System.IO;

namespace StoryBuilder
{

	//Debug arguments to use when debugging at home:
	//"c:\Dropbox\Human\stories-from-the-continuum\short-stories\02017-001-stories-from-the-continuum\02-jonas-is-flying" "c:\Dropbox\Human\stories-from-the-continuum\tools\static-content-generator" "Jonas is Flying"
	//Someplace else:
	//"e:\Dropbox\Human\stories-from-the-continuum\short-stories\02017-001-stories-from-the-continuum\01-a-source-of-creation" "..\..\..\..\..\static-content-generator" "A Source of Creation"

	class Program
  {
    static void Main(string[] args)
    {
      string targetDirectory = args[0] + @"\data\";
      string[] files = Directory.GetFiles(targetDirectory, "*.stseg", SearchOption.AllDirectories);

      string folderName = Path.GetFileNameWithoutExtension(args[0]);
      string fileName = folderName.Substring(folderName.IndexOf("-") + 1);
      string outputFile = args[0] + "\\" + fileName + ".html";
      
			string appPath = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
			string headerPath = appPath + args[1] + @"\header.htpart";
			string header = File.ReadAllText(headerPath);
      string footer = File.ReadAllText(appPath + args[1] + @"\footer.htpart");

			string outputData;
			outputData = header;
      outputData += "<H1>" + args[2] + "</H1>"; //Add story title.

      foreach (string file in files)
      {
        StreamReader segment = new StreamReader(file);
        string line;
        while ((line = segment.ReadLine()) != null)
        {
          int chapter = 0;
          //There is no space in this entire line? It is probably a chapter title then.
          //TODO: this is not ideal because it could treat a single lonely number as a chapter.
          if (line.IndexOf(" ") == -1)
          {
            //Trying to extract chapter name.
            int.TryParse(line, out chapter);
            if (chapter != 0)
            {
              outputData += "<H2>" + chapter + "</H2>";
            }
          }
          //It's a standard paragraph.
          if (chapter == 0)
          {
            outputData += "<P>";
            bool boldStarted = false;
            bool skipChar = false;
            int i = 0;
            foreach (char c in line)
            {
              if (skipChar)
              {
                skipChar = false;
                i++;
                continue;
              }
              if (c.ToString() == "*" && line[i + 1].ToString() == "*")
              {
                if (!boldStarted)
                {
                  outputData += "<strong>";
                }
                else
                {
                  outputData += "</strong>";
                }
                boldStarted = !boldStarted;
                skipChar = true;
                i++;
                continue;
              }

              outputData += c;
              i++;
            }
            outputData += "</P>";
          }
        }
      }
      outputData += footer;

      File.WriteAllText(outputFile, outputData);
    }
  }

}