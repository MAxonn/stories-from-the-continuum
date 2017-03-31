/**
 * Created by Axonn on 30-Mar-17.
 */

//var tocHeight = 0; //Required so that the iFrame is automatically resized.

//Shows story data such as title and table of contents.
function showStoryData(storyData)
{
	//Creates links from TOC data.
	_.each(storyData.toc, function(value)
	{
		$("#toc")
				.append("<a href='javascript:loadStorySegment(\"" + value.file + "\");'>" + value.rawDescription + "</a>")
				.append("<br/>");
		//TODO: write a nicer description based on raw description info.
		//TODO: generate iFrames programatically and load all story data.
	});
	//var tocContainer = ;
	$("#toc").append("<br/>");
	$("#title").append("<h1>" + storyData.title + "</h1>");
	//tocHeight = tocContainer.outerHeight(true);
}

//To be called when any link in the TOC is clicked.
function loadStorySegment(value)
{
	tocHeight = $("#toc").outerHeight(true);
	$("#ifrLoader")
			.attr('src', value);
			//.css('display','')
			//.height( $(window).height() - tocHeight);
}

function contentLoaded (iFrame)
{
	var storySegment = $("#ifrLoader").contents().find("pre").text();
	$("#content").empty();
	buildStoryHTML("content", storySegment.split('\n'));
}

//Resize of iFrame based on TOC height.
/*
$(window).resize(function()
{
	$('#content').height( $(window).height() - tocHeight);
}).resize();
*/
