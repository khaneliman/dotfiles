#!/usr/bin/env sh

sketchybar --add alias "Control Center,Bluetooth" right                                     \
           --rename "Control Center,Bluetooth" bluetooth_alias                              \
           --set        bluetooth_alias   icon.drawing=off                                  \
                                          label.drawing=off                                 \
                                          alias.color="$ORANGE"                             \
                                          background.padding_right=0                        \
                                          align=right                                       \
                                          script="$PLUGIN_DIR/bluetooth.sh"                 \
                                          click_script="$PLUGIN_DIR/bluetooth_click.sh"     \
            --subscribe  bluetooth_alias  mouse.entered                                     \
                                          mouse.exited                                      \
                                          mouse.exited.global                               \
                                                                                            \
            --add       item              bluetooth.template popup.bluetooth_alias          \
            --set                         bluetooth.template drawing=off                    \
                                          background.corner_radius=12                       \
                                          background.padding_left=7                         \
                                          background.padding_right=7                        \
                                          icon.background.height=2                          \
                                          icon.background.y_offset=-12
