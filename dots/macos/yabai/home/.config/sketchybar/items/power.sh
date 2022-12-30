#!/usr/bin/env sh
sketchybar -m --add item    battery right \
              --set battery update_freq=3 \
                            script="~/.config/sketchybar/plugins/power.sh" \
                            icon.font="CaskaydiaCove NF:Bold:15.0"       
