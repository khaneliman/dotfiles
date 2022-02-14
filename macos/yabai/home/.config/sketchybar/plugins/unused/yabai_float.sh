#!/usr/bin/env bash

case "$(yabai -m query --windows --window | jq ."is-floating" == true)" in
    0)
    sketchybar -m --set yabai_float icon=""
    ;;
    1)
    sketchybar -m --set yabai_float icon=""
    ;;
esac

