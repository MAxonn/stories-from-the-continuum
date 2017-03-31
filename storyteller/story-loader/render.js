/**
 * Created by Axonn on 31-Mar-17.
 */

function buildStoryHTML(targetElementID, paragraphs)
{
	_.each(paragraphs, function(value)
	{
		$("#" + targetElementID).append("<p>" + value + "</p>");
	});
}