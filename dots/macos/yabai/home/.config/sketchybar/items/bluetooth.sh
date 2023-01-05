#!/usr/bin/env sh

sketchybar --add alias "Control Center,Bluetooth" right                            \
           --rename "Control Center,Bluetooth" bluetooth_alias                     \
           --set bluetooth_alias icon.drawing=off                                  \
                              label.drawing=off                                    \
                              alias.color="$ORANGE"                                 \
                              background.padding_right=0                           \
                              align=right                                          \
                              click_script="$PLUGIN_DIR/bluetooth_click.sh"        \
