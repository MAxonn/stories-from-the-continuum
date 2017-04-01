var SS_01_SFTC_ASourceOfCreation_TOC = [];

SS_01_SFTC_ASourceOfCreation_TOC.push( { file: "data/01.stseg", rawDescription: "1..."} );
SS_01_SFTC_ASourceOfCreation_TOC.push( { file: "data/02.stseg", rawDescription: "...1"} );

var SS_01_SFTC_ASourceOfCreation_Data =
		{
			baseURL: "short-stories/02017-001-stories-from-the-continuum/" +
			"01-a-source-of-creation/",
			title: "A Source of Creation",
			toc: SS_01_SFTC_ASourceOfCreation_TOC
		};

$(document).ready(onReady);

//Registers the story, since arguments can't be passed to the jQuery onReady handler.
function onReady()
{
	registerStory(SS_01_SFTC_ASourceOfCreation_Data);
}