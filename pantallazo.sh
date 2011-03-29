#!/bin/sh

# @author Adrian Schlegel <fantomas.san@gmail.com>
# This is a simple script which creates a screenshot, puts it in your
# dropbox folder, creates a short URL for the public URL to the file and
# copies it to the clipboard.
# The idea for this script came from a similar screenshot script screenie.sh
# by mark@bhalash.com

# PREREQUISITES:
# - a dropbox account
# - the dropbox software installed on your computer
# - ImageMagick
# - wget (usually part of the base system)
# - xclip (optional)
#
# This script should run without any additional changes.
# If you have xclip installed it will copy the shortened URL to your
# clipboard. Otherwise you get a message window with the URL.

# INSTALLATION
# Usually you want to put this script in ~/bin/ (the bin directory in your
# home directory).
# For easier access you can create a keyboard shortcut in your desktop
# environment. The command you enter should look something like this:
# '/bin/sh /home/johndoe/bin/pantallazo.sh'

IMAGICKIMPORT=$(which import)
WGET=$(which wget)
DROPBOX=$(which dropbox)
XCLIP=$(which xclip)
if [ -z "$IMAGICKIMPORT" ]
then
    echo "You don't seem to have imagemagick installed. Please install it first."
    exit 1
fi

if [ -z "$WGET" ]
then
    echo "You don't seem to have wget installed. Please install it first."
fi

if [ -z "$DROPBOX" ]
then
    echo "You don't seem to have dropbox installed. Please install it first."
    echo "If you don't have a dropbox account you can create one here: http://db.tt/qvmfCOS"
fi

###############################################################################
# configuration (usually you don't have to change anything here)              #
###############################################################################
DBDIR=~/Dropbox/Public # path to your drobox public folder on your machine
SSDIR=screenshots # directory inside the public folder that receives the screenshots
LIIPTO="http://liip.to/api/txt/?url=" # URL shortener service
LOG=~/.pantallazo.log

[ -d $DBDIR/$SSDIR ] || mkdir $DBDIR/$SSDIR
cd $DBDIR/$SSDIR

SSFILE=$(date +%Y%m%d%H%M%S).jpg

import -quality 95 $SSFILE

PUBURL=$(dropbox puburl $DBDIR/$SSDIR/$SSFILE)
SHORTURL=$(wget -q -O - ${LIIPTO}$PUBURL)

if [ -z "$XCLIP" ]
then
    xmessage $SHORTURL
else
    echo $SHORTURL | xclip -sel clip
fi

if [ -n "$LOG" ]
then
    echo "`date '+%Y%m%d %H:%M:%S:'` $PUBURL | $SHORTURL" >> $LOG
fi

exit $?
