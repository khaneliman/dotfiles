#!/usr/bin/env bash

TOPPROC=$(
  
)
CPUP=$(echo $TOPPROC | sed -nr 's/([^\%]+).*/\1/p')

if [ $CPUP -gt 75 ]; then
  sketchybar -m --set $NAME label="異 $TOPPROC"
else
  sketchybar -m --set $NAME label=""
fi

