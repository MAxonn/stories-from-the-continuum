/**
 * Created by Axonn Echysttas on 2017-03-28.
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
function loadStory(baseURL, storyData)
{
	_storyData = storyData;
	//TODO: this might be a bit too many requests for stories with dozens of segments. Implement sequential loading.
  _.each(storyData.toc, function (tocItem)
  {
	  _segmentsToLoad++;
	  //Create new objects to contain each segment's data and store them in array
	  //so that they keep the proper sort order independent on what request completes first.
	  var segmentData = {  };
	  _segmentsData.push(segmentData);
	  //Request story segment.
	  $.get(baseURL + tocItem.file, null, function(storyLines)
	  {
		  segmentData.lines = storyLines;
		  segmentLoaded();
	  }, "text");
  });
	_loadStoryCommandsQueued = true;
}

//When all segments are loaded, will show the story.
function segmentLoaded()
{
	_segmentsToLoad--;
	if (_segmentsToLoad === 0 && _loadStoryCommandsQueued === true)
	{
		showStory();
	}
}

//Renders the story in the page.
function showStory()
{
	$("#title").append("<h1>" + _storyData.title + "</h1>");
  _.each(_segmentsData, function(value)
  {
  	buildStoryHTML("story", value.lines.split("\n"));
  });
}