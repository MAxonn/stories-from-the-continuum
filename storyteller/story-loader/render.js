/**
 * Created by Michael Axonn on 31-Mar-17.
 */

//Adds in a certain element all the paragraphs (lines of text) provided.
function buildStoryHTML(targetElementID, paragraphs)
{
	_.each(paragraphs, function(value)
	{
		$("#" + targetElementID).append("<p>" + value + "</p>");
	});
}