#!/bin/bash

VIDEOS_FOLDER=/Volumes/Untitled/DCIM/1/*
DESTINATION_FOLDER=/Users/samuel/Desktop/PriscilaVideos

REGEX=".*\/(.*)\.AVI"


for f in $VIDEOS_FOLDER; do    
    [[ $f =~ $REGEX ]]
    echo "Converting: ${BASH_REMATCH[1]}"

    ffmpeg -i $f $DESTINATION_FOLDER/${BASH_REMATCH[1]}.mp4
done
