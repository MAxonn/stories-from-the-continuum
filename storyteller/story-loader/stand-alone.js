/**
 * Created by Michael Axonn on 30-Mar-17.
 */

//TODO: add TOC back.
//TODO: Create anchors inside content div, to facilitate TOC navigation.
//TODO: write a nicer TOC chapter description based on raw description info.

//Story segments to load.
var _segmentsToLoad = [];
var _currentSegment = 0;

//Shows story data such as title and table of contents.
function showSingleStory(storyData)
{
	$("#content").empty();
	//Creates links from TOC data.
	_.each(storyData.toc, function(value)
	{
		/*
		$("#toc")
				.append("<a href='javascript:loadStorySegment(\"" + value.file + "\");'>" + value.rawDescription + "</a>")
				.append("<br/>");
		*/
		_segmentsToLoad.push(value.file);
	});
	$("#title").append("<h1>" + storyData.title + "</h1>");
	loadNextSegment();
}

//Passes the URL of the next story segment to the iFrame, prepares for next segment.
function loadNextSegment()
{ //If we're done loading all segments.
	if (_currentSegment == _segmentsToLoad.length)
	{
		return;
	}
	$("#ifrLoader").attr('src', _segmentsToLoad[_currentSegment]);
	_currentSegment++;
}

//Called from each stand-alone story page when the iFrame has finished loading a file it was requested to load.
//Transforms text in the iFrame into HTML elements in the page.
function contentLoaded (iFrame)
{
	var storySegment = $("#ifrLoader").contents().find("pre").text();
	//This function will generate required markup in the HTML element with the ID "content".
	buildStoryHTML("content", storySegment.split('\n'));
	loadNextSegment();
}