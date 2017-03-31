/**
 * Created by Axonn Echysttas on 2017-03-28.
 */

/*
//Loads script containing data about the story's segments.
//When done, loads the story using that data.
$.getScript(KST_REMOTE_URL +
		"short-stories/02017-001-stories-from-the-continuum/" +
		"01-a-source-of-creation/data/a-source-of-creation.sttoc.js",
		function() {
			$(document).ready(
					loadStory(KST_REMOTE_URL +
							"short-stories/02017-001-stories-from-the-continuum/" +
							"01-a-source-of-creation/",
							SS_SFTC_2017_ASourceOfCreation_Data));
		});

*/

//Loads script containing data about the story's segments.
//When done, loads the story using that data.
$.getScript(KST_REMOTE_URL +
		"short-stories/02017-001-stories-from-the-continuum/" +
		"02-jonas-is-flying/data/jonas-is-flying.sttoc.js",
		function() {
			$(document).ready(
					loadStory(KST_REMOTE_URL +
							"short-stories/02017-001-stories-from-the-continuum/" +
							"02-jonas-is-flying/",
							SS_SFTC_2017_JonasIsFlying_Data));
		});