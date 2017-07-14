@echo off

REM Must memorize current path.
set currentPath=%CD%
echo %currentPath%
cd..
cd..
cd..
cd tools\static-content-generator\storybuilder\storybuilder\bin\debug\
StoryBuilder.exe "%currentPath%" "..\..\..\..\..\..\static-content-generator" "A Source of Creation"