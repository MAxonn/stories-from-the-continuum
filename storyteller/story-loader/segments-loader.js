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
var _segmentsData = []; //Array with all story segments.
var _storyData; //Current story data.
var _loadStoryCommandsQueued = false; //Signals that all commands to load story data were queued.
var _multiStoryMode = false; //Load multiple stories. In this mode, previous HTML will not be cleared when showing story.
var _nextStory = 0; //Next story to load in multiple story mode.



//Loads all segments of a story using a base URL where they are located.
function loadStory (storyIndex)
{
	if (_multiStoryMode && storyIndex == _registeredStories)
	{
		console.debug("Done loading all stories.");
		return;
	}

	_storyData = _storyDatas[storyIndex];
	console.debug("Loading story with index: " + storyIndex + " titled '" + _storyData.title + "'");

	_segmentsData = [];
	//TODO: this might be a bit too many requests for stories with dozens of segments. Implement sequential loading.
	_.each(_storyData.toc, function(tocItem)
	{
		_segmentsToLoad++;
		//Create new objects to contain each segment's data and store them in array
		//so that they keep the proper sort order independent on what request completes first.
		var segmentData = {};
		_segmentsData.push(segmentData);

		//Infer base URL from story data URL location.
		console.debug("Loading segments for story with Story Data Script: " + _storyDataScriptURLsToLoad[storyIndex]);
		var storyBaseURL = _storyDataScriptURLsToLoad[storyIndex].substr(0, _storyDataScriptURLsToLoad[storyIndex].lastIndexOf("/"));
		console.debug("Segments location: " + storyBaseURL);

		//Request story segment.
		jQuery.get(storyBaseURL + "/" + tocItem.file, null, function(storyLines)
		{
			segmentData.lines = storyLines;
			segmentLoaded();
		}, "text");
	});
	_loadStoryCommandsQueued = true;
}

//Loads all the stories that have been registered.
function loadAllStories ()
{
	_multiStoryMode = true;
	loadStory(_nextStory);
}

//When all segments are loaded, will show the story.
function segmentLoaded ()
{
	_segmentsToLoad--;
	if (_segmentsToLoad === 0 && _loadStoryCommandsQueued === true)
	{
		showStory();
		if (_multiStoryMode)
		{
			loadStory(++_nextStory);
		}
	}
}

//Renders the story in the page.
function showStory ()
{
	if (!_multiStoryMode)
	{
		//Clear existing content.
		jQuery("#story").empty();
	}

	jQuery("#story").append("<h3>" + _storyData.title + "</h3>");
	//Render all segments.
	_.each(_segmentsData, function(value)
	{
		buildStoryHTML("story", value.lines.split("\n"));
	});
}