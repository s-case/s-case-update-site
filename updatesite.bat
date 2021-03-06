:: Script used to commit a new update site.
:: This script must be called after compiling with maven.
:: This script is for Windows OS. Use updatesite.sh for Linux OS.
:: Note that this script assumes that the s-case-update-site repository is placed
:: in the same level as the s-case.github.io repository in your file system
:: e.g. C:\Users\user\git\s-case-update-site and C:\Users\user\git\s-case.github.io

:: Navigate up twice and then in the s-case_update_site of the s-case.github.io repo
cd ..\s-case.github.io

:: Pull from the s-case.github.io repo
git pull

:: Delete the s-case_update_site folder from git
git rm -r s-case_update_site

:: Create the s-case_update_site folder if it does not exist
if not exist s-case_update_site mkdir s-case_update_site

:: Copy the update site from the s-case-update-site\update-site folder of the s-case repo in the
:: s-case_update_site of the s-case.github.io repo
xcopy ..\s-case-update-site\update-site\target\repository s-case_update_site\ /s /e /Y

:: Navigate into the newly created s-case_update_site folder
cd s-case_update_site

:: Add an index.html file to explain this is an update site
echo ^<!DOCTYPE html^> > index.html
echo ^<!-- Warning: this file is auto-generated! Any changes are deleted upon each update site commit! --^> >> index.html
echo ^<html^> >> index.html
echo   ^<head^>^<title^>S-CASE Update Site^</title^>^</head^> >> index.html
echo   ^<body^>^<div^>^<p^> >> index.html
echo       This page is an update site location. For info, redirect back to the ^<a href="http://s-case.github.io/"^>main^</a^> page.^<br /^> >> index.html
echo       Adding the s-case tools in eclipse requires adding the repository address:^<br /^> >> index.html
echo       ^<code^>http://s-case.github.io/s-case_update_site/^</code^> >> index.html
echo       ^<br /^>in your eclipse repositories. >> index.html
echo   ^</p^>^</div^>^</body^> >> index.html
echo ^</html^> >> index.html

:: Navigate back to the root of the s-case.github.io repo
cd ..

:: Add the s-case_update_site folder in the commit
git add s-case_update_site

:: Commit the new update site files
git commit -a -m "Update Site Commit"

:: Push the updates at the remote repo
:: This action requires github username and password
git push origin master

:: Navigate up and then in the initial directory (s-case-update-site repo)
cd ..\s-case-update-site
