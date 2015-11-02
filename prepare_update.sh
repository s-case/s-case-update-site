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

mkdir -p $TMPDIR

trap 'rm -rf $TMPDIR' 0 2 15

cd $TMPDIR

if [ "XOPENSHIFT_DATA_DIR" = "X" ] ; then
    SETTINGS_XML=$HOME/.m2/settings.xml
else
    SETTINGS_XML=$OPENSHIFT_DATA_DIR/settings.xml
fi

echo everything locally
#for i in s-case-core.git storyboard-creator.git requirements-editor.git uml-extraction.git web-service-composition.git mde.git; do
for i in s-case-core.git ; do
   git clone https://scaseAtsDeveloper:scaseAtsDeveloper,01@github.com/s-case/$i $i
   (cd $i && mvn -s $SETTINGS_XML clean install)
done

