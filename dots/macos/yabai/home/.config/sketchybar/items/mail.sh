#!/usr/bin/env sh

sketchybar --add item mail right                    \
           --set mail update_freq=60                \
                      icon.font="$FONT:Bold:16.0"  \
                      icon.color=$BLUE \
                      script="$PLUGIN_DIR/mail.sh"  \
                      label=!                       \
                      background.color=$ITEM_COLOR  \
                      background.height=23          \
                      background.corner_radius=$CORNER_RADIUS \
                      background.padding_right=10