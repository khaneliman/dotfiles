#!/usr/bin/env sh

sketchybar --add alias "Control Center,WiFi" right                            \
           --rename "Control Center,WiFi" wifi_alias                     \
           --set wifi_alias icon.drawing=off                                  \
                              label.drawing=off                                    \
                              alias.color="$YELLOW"                                 \
                              background.padding_right=0                           \
                              align=right                                          \
                              # click_script="$PLUGIN_DIR/wifi_click.sh"        \
