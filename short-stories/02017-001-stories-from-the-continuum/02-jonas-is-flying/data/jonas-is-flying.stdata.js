var SS_01_SFTC_JonasIsFlying_TOC = [];

SS_01_SFTC_JonasIsFlying_TOC.push( { file: "data/01.stseg", rawDescription: "1"} );
SS_01_SFTC_JonasIsFlying_TOC.push( { file: "data/02.stseg", rawDescription: "2"} );
SS_01_SFTC_JonasIsFlying_TOC.push( { file: "data/03.stseg", rawDescription: "3"} );
SS_01_SFTC_JonasIsFlying_TOC.push( { file: "data/04.stseg", rawDescription: "4"} );

var SS_01_SFTC_JonasIsFlying_Data =
		{
			baseURL: "short-stories/02017-001-stories-from-the-continuum/" +
			"02-jonas-is-flying/",
			title: "Jonas Is Flying",
			toc: SS_01_SFTC_JonasIsFlying_TOC
		};

$(document).ready(onReady);

//Registers the story, since arguments can't be passed to the jQuery onReady handler.
function onReady()
{
	registerStory(SS_01_SFTC_JonasIsFlying_Data);
}