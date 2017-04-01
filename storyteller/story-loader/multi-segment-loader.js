/**
 * Created by Michael Axonn on 2017-03-28.
 *
 * Loads all the segments of a story.
 * The entry point of this script is the loadStory function.
 *
 * REQUIRES: _storyDatas from loader-multi-story.js
 */

//Total number of segments to load. Used to make sure we wait for all requests to complete
//before showing the story.
var _segmentsToLoad = 0;
//Array with all story segments.
var _segmentsData = [];
//Current story data.
var _storyData;
//Signals that all commands to load story data were queued.
var _loadStoryCommandsQueued = false;



//Loads all segments of a story using a base URL where they are located.
function loadStory (storyIndex)
{
	_storyData = _storyDatas[storyIndex];
	_segmentsData = [];
	//TODO: this might be a bit too many requests for stories with dozens of segments. Implement sequential loading.
	_.each(_storyData.toc, function(tocItem)
	{
		_segmentsToLoad++;
		//Create new objects to contain each segment's data and store them in array
		//so that they keep the proper sort order independent on what request completes first.
		var segmentData = {};
		_segmentsData.push(segmentData);
		//Request story segment.
		$.get(_storyData.baseURL + tocItem.file, null, function(storyLines)
		{
			segmentData.lines = storyLines;
			segmentLoaded();
		}, "text");
	});
	_loadStoryCommandsQueued = true;
}

//When all segments are loaded, will show the story.
function segmentLoaded ()
{
	_segmentsToLoad--;
	if (_segmentsToLoad === 0 && _loadStoryCommandsQueued === true)
	{
		showStory();
	}
}

//Renders the story in the page.
function showStory ()
{
	//Clear existing content.
	$("#story").empty();
	$("#title").empty().append("<h3>" + _storyData.title + "</h3>");
	//Render all segments.
	_.each(_segmentsData, function(value)
	{
		buildStoryHTML("story", value.lines.split("\n"));
	});
}