using System.IO;



namespace StoryBuilder
{

  class Program
  {
    static void Main(string[] args)
    {
      string targetDirectory = args[0] + @"\data\";
      string[] files = Directory.GetFiles(targetDirectory, "*.stseg", SearchOption.AllDirectories);

      string folderName = Path.GetFileNameWithoutExtension(args[0]);
      string fileName = folderName.Substring(folderName.IndexOf("-") + 1);
      string outputFile = args[0] + "\\" + fileName + "-OFFLINE.html";
      
      string outputData;
      string header = File.ReadAllText(args[1] + @"\header.htpart");
      string footer = File.ReadAllText(args[1] + @"\footer.htpart");
      outputData = header;

      outputData += "<H1>" + args[2] + "</H1>";

      foreach (string file in files)
      {
        StreamReader segment = new StreamReader(file);
        string line;
        while ((line = segment.ReadLine()) != null)
        {
          int chapter = 0;
          if (line.IndexOf(" ") == -1)
          {
            int.TryParse(line, out chapter);
            if (chapter != 0)
            {
              outputData += "<H2>" + chapter + "</H2>";
            }
          }
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