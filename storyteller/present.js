/**
 * Created by Michael Axonn on 2017-03-28.
 */

var _storyDataScriptURLs = [];

_storyDataScriptURLs.push("short-stories/02017-001-stories-from-the-continuum/" +
		"01-a-source-of-creation/data/a-source-of-creation.stdata.js");
_storyDataScriptURLs.push("short-stories/02017-001-stories-from-the-continuum/" +
		"02-jonas-is-flying/data/jonas-is-flying.stdata.js");

$(document).ready(loadMultipleStories(_storyDataScriptURLs));