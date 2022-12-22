#!/usr/bin/env bash

# Add mode changed event

case "$(yabai -m query --spaces --display | jq -r 'map(select(."has-focus" == true))[-1].type')" in
    bsp)
    yabai -m config layout stack && sketchybar -m --set yabai_mode label="﯅"
    ;;
    stack)
    yabai -m config layout float && sketchybar -m --set yabai_mode label=""
    ;;
    float)
    yabai -m config layout bsp && sketchybar -m --set yabai_mode label=""
    ;;
esac