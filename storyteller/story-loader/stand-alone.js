/**
 * Created by Axonn on 30-Mar-17.
 */

//TODO: generate iFrames programatically and load all story data in a sequential loop
//TODO: when above is done, create anchors inside div, to facilitate TOC navigation.
//TODO: write a nicer TOC chapter description based on raw description info.

//Shows story data such as title and table of contents.
function showStoryData(storyData)
{
	//Creates links from TOC data.
	_.each(storyData.toc, function(value)
	{
		$("#toc")
				.append("<a href='javascript:loadStorySegment(\"" + value.file + "\");'>" + value.rawDescription + "</a>")
				.append("<br/>");
	});
	$("#toc").append("<br/>");
	$("#title").append("<h1>" + storyData.title + "</h1>");
}

//To be called when any link in the TOC is clicked.
function loadStorySegment(value)
{
	tocHeight = $("#toc").outerHeight(true);
	$("#ifrLoader").attr('src', value);
}

function contentLoaded (iFrame)
{
	var storySegment = $("#ifrLoader").contents().find("pre").text();
	$("#content").empty();
	buildStoryHTML("content", storySegment.split('\n'));
}