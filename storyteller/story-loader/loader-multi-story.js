/**
 * Created by Michael Axonn on 31-Mar-17.
 *
 * Used by multi-story pages. Loads any number of story Data Scripts.
 * The entry point of this script is the loadMultipleStories function, to which an array of story Data Script URLs must be provided.
 * (the URLs point to files with stdata.js extension located in the /data folder of any story).
 *
 */

//Total number of stories registered so far.
var _registeredStories = 0;

//An array containing Story Data objects. Stories call back with their data once their scripts are loaded.
var _storyDatas = [];

//An array containing Story Data Script URLs. The scripts will call back and offer Story Data.
var _storyDataScriptURLsToLoad;
var _storyDataScriptIndexToLoad = 0; //Keeps track of the scripts that still require loading.



//Called when multiple stories need to be loaded.
//This will initiate the loading of the first Story Data script.
function loadMultipleStories(storyDataScriptURLs)
{
	_storyDataScriptURLsToLoad = storyDataScriptURLs;
	loadNextStoryDataScript();
}

//Loads all scripts mentioned in _storyDataScriptURLsToLoad.
//Will be called back after every load, until all scripts have been loaded.
function loadNextStoryDataScript ()
{
	//Nothing left to load.
	if (_storyDataScriptIndexToLoad == _storyDataScriptURLsToLoad.length)
	{
		return;
	}
	jQuery.getScript(KST_REMOTE_URL + _storyDataScriptURLsToLoad[_storyDataScriptIndexToLoad++]);
}

//Called by a story's data file (.stdata.js extension) script in order to offer the Story Teller data about that story.
//The call will occur on document.ready for all story data scripts that are loaded.
function registerStory (storyData)
{
	console.debug("The following story has registered: " + storyData.title);
	_storyDatas.push(storyData);
	_registeredStories++;
	//When all stories that required loading are loaded, preparing the menu.
	if (_registeredStories == _storyDataScriptURLsToLoad.length)
	{
		console.debug("All stories have registered");
		//Are we using a menu for loading stories?
		if (KST_BUILD_MENU == 1)
		{
			buildStoriesMenu();
		}
		//If not, automatically loading the first story.
		else
		{
			loadStory(1);
		}
	}
	//Load the next story script.
	else
	{
		loadNextStoryDataScript();
	}
}

//Builds a list of links for all stories that have registered themselves
//(all the stories specified in _storyDataScriptURLsToLoad).
function buildStoriesMenu ()
{
	//Making the list in the order indicated by the Story Data Scripts array.
	//This is because the Story Datas array (which consists of Story Data that was provided once
	//a Data Scripts loaded) may have different order due to load sequence.
	_.each(_storyDataScriptURLsToLoad, function (storyDataScriptURL)
	{
		var i = 0; //Used to keep track of what Story Data matches what Story Data Script.
		//Now find the Story Data associated with this Story Data Script.
		_.each(_storyDatas, function(storyData)
		{
			var storyBaseURL = _storyDataScriptURLsToLoad[i].substr(0, _storyDataScriptURLsToLoad[i].lastIndexOf("/"));
			//Matching is done by checking if the URL of the Story Data Script contains the Base URL inside Story Data.
			if (storyDataScriptURL.indexOf(storyBaseURL) != -1)
			{
				//Add a link that will call the loadStory function.
				jQuery("#stories")
						.append("<a href='javascript:loadStory(" + (i).toString() + ")'>" + storyData.title + "</a>")
						.append("</br>");
				return false; //Item found! Break the each loop.
			}
			i++;
		});
	});

}