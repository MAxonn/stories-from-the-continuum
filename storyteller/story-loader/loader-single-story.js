/**
 * Created by Michael Axonn on 30-Mar-17.
 *
 * Used by stand-alone story pages. Loads all the data files of a single story.
 * The entry point of this script is the registerStory function, which will be called by the story's Data Script upon document.ready.
 *
 * A stand-alone story page will include this script, as well as its own Data Script
 * (a file with stdata.js extension located in the /data folder of the story).
 *
 */

//TODO: add TOC back.
//TODO: Create anchors inside content div, to facilitate TOC navigation.
//TODO: write a nicer TOC chapter description based on raw description information in story dat.toc.

var _currentSegment = 0; //Currently loaded story segment.
var _storyData; //Data of the story being loaded.

//Called by the currently loaded story's Data Script (stdata.js extension).
function registerStory (storyData)
{
	_storyData = storyData;
	$("#title").append("<h1	>" + storyData.title.toString() + "</h1>");
	loadNextSegment();
}

//Passes the URL of the next story segment to the iFrame, prepares for next segment.
function loadNextSegment()
{ //If we're done loading all segments.
	if (_currentSegment == _storyData.toc.length)
	{
		return;
	}
	$("#ifrLoader").attr('src', 'data/' + _storyData.toc[_currentSegment].file);
	_currentSegment++;
}

//Called from each stand-alone story page when the iFrame has finished loading a file it was requested to load.
//Transforms text in the iFrame into HTML elements in the page.
function contentLoaded (iFrame)
{
	if (iFrame.src.toString().trim().length == 0)
	{
		return;
	}
	var storySegment = $("#ifrLoader").contents().find("pre").text();
	//This function will generate required markup in the HTML element with the ID "content".
	buildStoryHTML("content", storySegment.split('\n'));
	loadNextSegment();
}