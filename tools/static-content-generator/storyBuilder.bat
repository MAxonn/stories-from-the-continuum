REM This batch script is to be executed from the same folder where a story is located.
REM Use the build-story.bat located inside a story's folder!
@echo off

REM Must use Unicode.
chcp 65001

REM go to where all the story segments are located.
cd %1

REM @@@@@@@@@@@@@@@
REM @@@@@@@@@@@@@@@ File name setup, story name setup.
REM @@@@@@@@@@@@@@@

REM Find what is the name of this story and create the file name for it.
for %%* in (.) do set storyTitle=%%~nx*
set storyTitleSansNumber=%storyTitle:~3,200%
set storyFileName=%storyTitleSansNumber%-OFFLINE.html
echo Computed Story File Name is: %storyFileName%

REM Obtain capitalized story name.
set wordsInName=%storyTitleSansNumber:-= %
set capitalizedStoryName=
set "spaceToken= "
setlocal EnableDelayedExpansion
for /f "delims=" %%a in ("%wordsInName%") do for %%b in (%%a) do (
	REM Check for Chicago Manual of Style words that shouldn't be capitalized.
	set avoidCapitalizationOfChicagoManualOfStyleWords=F
	REM TODO: this list is so far NOT exhaustive. A file should be created from where these words should be read.
	if "%%b%" == "of" set avoidCapitalizationOfChicagoManualOfStyleWords=T
	REM Do not capitalize Chicago Manual of Style words that shouldn't be capitalized.
	if "!avoidCapitalizationOfChicagoManualOfStyleWords!" == "T" (
		REM Add title word without capitalizing.
	  set capitalizedStoryName=!capitalizedStoryName!%%b!spaceToken!
	) else (
		REM Capitalize title word.
		call :CapitalizeWord result %%b
		set capitalizedStoryName=!capitalizedStoryName!!result!
	)
)

echo Computed Capitalized Story Name is: %capitalizedStoryName%
setlocal DisableDelayedExpansion

goto :startBuildHTML

:CapitalizeWord
setlocal EnableDelayedExpansion
set "temp=%~2"
set "helper=##AABBCCDDEEFFGGHHIIJJKKLLMMNNOOPPQQRRSSTTUUVVWWXXYYZZ"
set "first=!helper:*%temp:~0,1%=!"
set "first=!first:~0,1!"
if "!first!"=="#" set "first=!temp:~0,1!"
set "temp=!first!!temp:~1!"
(
    endlocal
		REM Make sure we add space before each word.
    set "result=%temp% "
    goto :eof
)

:startBuildHTML

REM @@@@@@@@@@@@@@@
REM @@@@@@@@@@@@@@@ Building Story HTML.
REM @@@@@@@@@@@@@@@

REM Remove any existing story file.
del %storyFileName%
REM Go to the Data folder where all story files are.

REM String constants.
REM New line.
set LF=^& echo.
REM HTML P tag.
set "PO=^<P^>"
set "PC=^</P^>"
REM HTML DIV tag.
set "DIO=^<DIV^>"
set "DIC=^</DIV^>"
REM HTML H1 tag.
set "H1O=^<H1^>"
set "H1C=^</H1^>"

REM Add HTML header with story title.
setlocal enableDelayedExpansion
cd data
for /f "delims=" %%x in (../../../../tools/static-content-generator/header.htpart) do (
	set "safe=%%x"
	set "safe=!safe:"=""!"
	call :putLineInHTMLFile "!safe!"
)
setlocal disableDelayedExpansion

REM Add Story Title
echo %H1O%>> %storyFileName%
echo %capitalizedStoryName%>> %storyFileName%
echo %H1C%>> %storyFileName%

REM Go back to parent folder. Otherwise, weird things happen (we get left out in /data folder).
cd..

REM @@@@@@@@@@@@@@@
REM @@@@@@@@@@@@@@@ This is where all segment data is copied into the HTML file, line by line, as individual paragraphs.
REM @@@@@@@@@@@@@@@

REM Loop through the story segment files in this folder.
cd data
for %%f in (*.stseg) do call :appendToHTML %%f
cd..

goto :finalizeBuildHTML

REM @@@@@@@@@@@@@@@
REM @@@@@@@@@@@@@@@ HTML Utility functions.
REM @@@@@@@@@@@@@@@

:appendToHTML

set fileName=%*
echo PROCESSING: %fileName%
for /f "delims=" %%x in (%fileName%) do call :putParagraphInHTMLFile %%x

goto :eof

REM this label uses delayed expansion.
:putLineInHTMLFile

set "line=%~1"
set "line=%line:""="%"
echo !line!>> !storyFileName!

goto :eof

REM this label DOES NOT use delayed expansion (because it handles story segments and there are exlamation marks there but NO angular brakets).
:putParagraphInHTMLFile

echo %PO%>> %storyFileName%
echo %*>> %storyFileName%
echo %PC%>> %storyFileName%

goto :eof

REM @@@@@@@@@@@@@@@
REM @@@@@@@@@@@@@@@ HTML completion.
REM @@@@@@@@@@@@@@@

:finalizeBuildHTML

REM Add HTML footer.
setlocal enableDelayedExpansion
cd data
for /f "delims=" %%x in (../../../../tools/static-content-generator/footer.htpart) do (
	set "safe=%%x"
	set "safe=!safe:"=""!"
	call :putLineInHTMLFile "!safe!"
)
cd..
setlocal disableDelayedExpansion

REM Move file to its proper location.
move data\%storyFileName% %storyFileName%

:eof