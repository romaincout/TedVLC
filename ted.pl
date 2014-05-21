#!/usr/bin/perl -w
use strict;
use warnings;
# remove previous tmp video
`cd /tmp ;  rm /tmp/ted.mp4*`;
# start youtube-dl'ing the ted video (in the background with open)
open YT, "youtube-dl -o /tmp/ted.mp4 $ARGV[0] |";
# DLing the list of subs
my $srtLink=`wget https://tedtalksubtitledownload.appspot.com/get_list\?url\=$ARGV[0] -O - -q`;
# Create SRT link from the first result 
    #TODO == propose to selection lang on multiple choice (or FR by default, EN if no FR, choice if no FR/EN)
$srtLink=~s@.*(get_sub[^"]*)".*@https://tedtalksubtitledownload.appspot.com/$1@;
# download sub
`wget -O /tmp/ted.srt "$srtLink"`;
sleep 3; # wait for file to exist (2 is problematic)
# start playing the video with the subs
`vlc /tmp/ted.mp4* --sub-file /tmp/ted.srt`;
# do something with open output and clode file handle
while( my $ligne = <YT> ) {
    print $ligne;
}
close YT
