/**
 * Created by Michael Axonn on 31-Mar-17.
 */

//Adds in a certain element all the paragraphs (lines of text) provided.
function buildStoryHTML(targetElementID, paragraphs)
{
	_.each(paragraphs, function(value)
	{
		var chapter = 0;
		//There is no space in this entire line? It is probably a chapter title then.
		//TODO: this is not ideal because it could treat a single lonely number as a chapter.
		if (value.indexOf(" ") == -1)
		{
			if (isInt(value))
			{
				chapter = value;
				value = "<H2>" + value + "</H2>";
			}
		}
		//Standard paragraph.
		if (chapter == 0)
		{
			while (value.indexOf("**") != -1)
			{
				var boldStartPos = value.indexOf("**");
				var boldEndPos = value.indexOf("**", boldStartPos + 1);
				if (boldEndPos == -1)
				{
					console.debug("Missing bold closing delimiter at " + boldStartPos);
					continue;
				}
				value = value.replace("**", "<strong>");
				value = value.replace("**", "</strong>");
			}
		}
		$("#" + targetElementID).append("<p>" + value + "</p>");
	});
}