@echo off

REM Must memorize current path.
set currentPath=%CD%

REM navigate to the Story Builder BAT.
cd..
cd..
cd..
cd tools
cd static-content-generator

REM Launch story builder with current path.
storyBuilder "%currentPath%"