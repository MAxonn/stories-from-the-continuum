/**
 * Created by Michael Axonn on 2017-03-28.
 */

//Remote URL from where to load data. Empty string means the current URL (even local storage) will be used.
//var KST_REMOTE_URL = "http://michaelaxonn.com/st/";
var KST_REMOTE_URL = "";

//All stories that can be shown.
var _storyDatas = [];

//Called by Story STTOC (Story Teller Table of Contents) scripts in order to
//give the Story Teller data about them.
function addStory (storyData)
{
	_storyDatas.push(storyData);
	storyRegistered(storyData);
}