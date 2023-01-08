#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item        memory right                 \
           --set memory      label.font="$FONT:Heavy:12"  \
                             label.color="$TEXT"          \
                             icon="$MEMORY"               \
                             icon.font="$FONT:Bold:16.0"  \
                             icon.color="$GREEN"          \
                             update_freq=2                \
                             script="$PLUGIN_DIR/ram.sh"
