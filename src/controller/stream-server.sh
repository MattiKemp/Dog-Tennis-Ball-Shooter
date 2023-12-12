#!/bin/sh
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT
./mjpg_streamer -i "input_uvc.so -y -r 1280x720 -f 20" -o "output_http.so -w `pwd`/www"

