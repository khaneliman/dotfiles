#!/bin/bash

APP_STATE=$(pgrep -x Music)
if [[ ! $APP_STATE ]]; then 
  sketchybar -m --set music_info drawing=on
  exit 0
fi

PLAYER_STATE=$(osascript -e "tell application \"Music\" to set playerState to (get player state) as text")
if [[ $PLAYER_STATE == "stopped" ]]; then
  sketchybar -m --set music_info drawing=on
  exit 0
fi

TITLE=$(osascript -e 'tell application "Music" to get name of current track')
ARTIST=$(osascript -e 'tell application "Music" to get artist of current track')
# ALBUM=$(osascript -e 'tell application "Music" to get album of current track')
LOVED=$(osascript -l JavaScript -e "Application('Music').currentTrack().loved()")

if [[ $LOVED == "true" ]]; then
  ICON=
else
  [[ $PLAYER_STATE == "paused" ]] && ICON= || ICON=
fi

if [[ ${#TITLE} -gt 25 ]]; then
  TITLE=$(printf "$(echo $TITLE | cut -c 1-25)…")
fi

if [[ ${#ARTIST} -gt 25 ]]; then
  ARTIST=$(printf "$(echo $ARTIST | cut -c 1-25)…")
fi

# if [[ ${#ALBUM} -gt 25 ]]; then
#   ALBUM=$(printf "$(echo $ALBUM | cut -c 1-12)…")
# fi

sketchybar -m --set music_info icon="$ICON" \
              --set music_info label="${TITLE} x ${ARTIST}" \
              --set music_info drawing=off