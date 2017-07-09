var SS_01_SFTC_JonasIsFlying_TOC = [];

SS_01_SFTC_JonasIsFlying_TOC.push( { file: "01.stseg", rawDescription: "1", authors: "Michael Axonn"} );
SS_01_SFTC_JonasIsFlying_TOC.push( { file: "02.stseg", rawDescription: "2", authors: "Michael Axonn"} );
SS_01_SFTC_JonasIsFlying_TOC.push( { file: "03.stseg", rawDescription: "3", authors: "Michael Axonn"} );
SS_01_SFTC_JonasIsFlying_TOC.push( { file: "04.stseg", rawDescription: "4", authors: "Michael Axonn"} );
SS_01_SFTC_JonasIsFlying_TOC.push( { file: "05.stseg", rawDescription: "5", authors: "Michael Axonn"} );
SS_01_SFTC_JonasIsFlying_TOC.push( { file: "06.stseg", rawDescription: "6", authors: "Michael Axonn"} );
SS_01_SFTC_JonasIsFlying_TOC.push( { file: "07.stseg", rawDescription: "7", authors: "Michael Axonn"} );

var SS_01_SFTC_JonasIsFlying_Data =
		{
			curator: "Michael Axonn",
			title: "Jonas Is Flying",
			toc: SS_01_SFTC_JonasIsFlying_TOC
		};

jQuery(document).ready(onReady);

//Registers the story, since arguments can't be passed to the jQuery onReady handler.
function onReady()
{
	registerStory(SS_01_SFTC_JonasIsFlying_Data);
}