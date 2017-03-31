/**
 * Created by Michael Axonn on 31-Mar-17.
 */

var _storyDataScriptIndex = 0;
var _registeredStories = 0; //Total number of stories registered so far.

$(document).ready(loadNextStoryDataScript);

//Loads all scripts mentioned in _storyDataScripts.
function loadNextStoryDataScript ()
{
	if (_storyDataScriptIndex == _storyDataScripts.length)
	{
		return;
	}
	$.getScript(KST_REMOTE_URL + _storyDataScripts[_storyDataScriptIndex++], loadNextStoryDataScript());
}

//Called from config/st.js when a story was loaded. When all required stories are loaded, will show them.
function storyRegistered(storyData)
{
	_registeredStories++;
	if (_registeredStories == _storyDataScripts.length)
	{
		showStories();
	}
}

//Builds a list of links for all stories in _storyDataScripts.
function showStories ()
{
	_.each(_storyDataScripts, function (storyDataScript)
	{
		var i = 0;
		_.each(_storyDatas, function(storyData)
		{
			if (storyDataScript.indexOf(storyData.baseURL) != -1)
			{
				$("#stories")
						.append("<a href='javascript:loadStory(" + (i).toString() + ")'>" + storyData.title + "</a>")
						.append("</br>");
				return false; //Break LODASH script.
			}
			i++;
		});
	});

}