#!/bin/bash

if [ $# -eq 0 ]
  then
    echo -e "\033[1;31mNo arguments supplied. Please specify name of video to be used!\033[0m"
  else
    if [ ! -d ./files ]; then
      mkdir -p files;
    fi
    ffmpeg -i $1 -r ${2:-1}  files/image-%5d.png
fi

