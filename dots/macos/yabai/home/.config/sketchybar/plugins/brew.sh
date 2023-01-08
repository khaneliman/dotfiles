#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

COUNT=$(brew outdated | wc -l | tr -d ' ')

COLOR=$RED

case "$COUNT" in
  [3-5][0-9]) COLOR=$PEACH
  ;;
  [1-2][0-9]) COLOR=$YELLOW
  ;;
  [1-9]) COLOR=$TEXT
  ;;
  0) COLOR=$GREEN
     COUNT=􀆅
  ;;
esac

sketchybar --set "$NAME" label="$COUNT" icon.color="$COLOR"
