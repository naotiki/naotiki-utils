#!/bin/bash
docker rm -f $(docker ps -a -q -f "ancestor=ffmpeg-nvidia")
docker build . -t ffmpeg-nvidia