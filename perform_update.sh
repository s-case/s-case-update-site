#!/bin/sh
# Script used to commit a new update site.
# This script must be called after compiling with maven.
# This script is for Linux OS. Use updatesite.bat for Windows OS.
# Note that this script assumes that the s-case-update-site repository is placed
# in the same level as the s-case.github.io repository in your file system
# e.g. /home/user/git/s-case-update-site and /home/user/git/s-case.github.io

echo check version
#VERSION=`mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate \
#    -Dexpression=project.version | \
#    grep -v Download | \
#    sed -n -e '/^[0-9]/ { p }'`
VERSION=1.0.0-SNAPSHOT

if [ "X$VERSION" = "X" ] ; then
    echo "Can't get current version";
    exit 1
fi

# test for SNAPSHOT
echo $VERSION | grep SNAPSHOT > /dev/null
IS_SNAPSHOT=$?

if [ "X$IS_SNAPSHOT" = "X0" ] ; then
    echo nightly build
    SITE_DIR=s-case_nightly_build_site
else
    echo stable build
    SITE_DIR=s-case_update_site
fi

DIR=`pwd`

TMPDIR=$DIR/target/$(basename $0).$$

trap 'rm -rf $TMPDIR' 0 2 15

# deleted up after mvn clean
mkdir -p $TMPDIR
cd $TMPDIR

echo check out existing update site
git clone git@github.com:s-case/s-case.github.io.git s-case.github.io.git

echo update existing update site
cd s-case.github.io.git

if [ ! -d $SITE_DIR ] ; then
    mkdir $SITE_DIR
fi

git rm -q -r $SITE_DIR/*

mkdir $SITE_DIR

cp -a $DIR/update-site/target/repository/* $SITE_DIR
# Add an index.html file to explain this is an update site
echo "<!DOCTYPE html>" > index.html
echo "<!-- Warning: this file is auto-generated! Any changes are deleted upon each update site commit! -->" >> index.html
echo "<html>" >> index.html
echo "  <head><title>S-CASE Update Site</title></head>" >> index.html
echo "  <body><div><p>" >> index.html
echo "      This page is an update site location. For info, redirect back to the <a href="http://s-case.github.io/">main</a> page.<br />" >> index.html
echo "      Adding the s-case tools in eclipse requires adding the repository address:<br />" >> index.html
echo "      <code>http://s-case.github.io/s-case_update_site/</code>" >> index.html
echo "      <br />in your eclipse repositories." >> index.html
echo "  </p></div></body>" >> index.html
echo "</html>" >> index.html
git add -A
git commit -am "automatic update"

#drop the history
#see http://stackoverflow.com/questions/13716658/how-to-delete-all-commit-history-in-github
echo drop history
git checkout --orphan latest_branch
git add -A
git commit -am "drop history"
git branch -D master
git branch -m master
git push -f origin master

exit
