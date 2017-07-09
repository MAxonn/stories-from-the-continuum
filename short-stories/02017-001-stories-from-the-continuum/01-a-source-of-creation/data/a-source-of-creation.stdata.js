var SS_01_SFTC_ASourceOfCreation_TOC = [];

SS_01_SFTC_ASourceOfCreation_TOC.push( { file: "01.stseg", rawDescription: "1...", authors: "Michael Axonn"} );
SS_01_SFTC_ASourceOfCreation_TOC.push( { file: "02.stseg", rawDescription: "...1", authors: "Michael Axonn"} );

var SS_01_SFTC_ASourceOfCreation_Data =
		{
			curator: "Michael Axonn",
			title: "A Source of Creation",
			toc: SS_01_SFTC_ASourceOfCreation_TOC
		};

jQuery(document).ready(onReady);

//Registers the story, since arguments can't be passed to the jQuery onReady handler.
function onReady()
{
	registerStory(SS_01_SFTC_ASourceOfCreation_Data);
}