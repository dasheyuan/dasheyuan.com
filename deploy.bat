@echo off
echo Deploying updates to GitHub...

rem Build the project.
hugo

rem Add changes to git.
git add -A
pause
