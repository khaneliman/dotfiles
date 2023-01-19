#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item        cpu.percent right                \
           --set cpu.percent label.font="$FONT:Heavy:12"      \
                             label=CPU%                       \
                             label.color="$TEXT"              \
                             icon="$CPU"                      \
                             icon.color="$BLUE"               \
                             update_freq=2                    \
                             mach_helper="$HELPER"


