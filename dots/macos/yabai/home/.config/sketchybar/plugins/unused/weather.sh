#!/usr/bin/env bash

WEATHER="$(curl -s 'wttr.in/Spring?format=%c%f')"
LABEL="$(echo "${WEATHER:3:-1}")"
ICON="$(echo "${WEATHER:0:1}")"

echo $LABEL
echo $ICON

sketchybar -m --set $NAME label=$LABEL

