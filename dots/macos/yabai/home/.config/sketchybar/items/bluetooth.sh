#!/usr/bin/env sh

sketchybar --add alias  "Control Center,Bluetooth" right                                    \
           --rename     "Control Center,Bluetooth" bluetooth.alias                          \
           --set        bluetooth.alias   icon.drawing=off                                  \
                                          alias.color="$PEACH"                              \
                                          background.padding_right=0                        \
                                          align=right                                       \
                                          click_script="$PLUGIN_DIR/bluetooth_click.sh"     \
                                          script="$PLUGIN_DIR/bluetooth.sh"                 \
                                          popup.height=30                                   \
                                          update_freq=1                                     \
            --subscribe  bluetooth.alias  mouse.entered                                     \
                                          mouse.exited                                      \
                                          mouse.exited.global                               \
                                                                                            \
            --add       item              bluetooth.details popup.bluetooth.alias           \
            --set       bluetooth.details	background.corner_radius=12                       \
                                          background.padding_left=5                         \
                                          background.padding_right=10                       \
                                          click_script="sketchybar --set bluetooth.alias popup.drawing=off"
