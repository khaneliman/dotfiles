#!/usr/bin/env sh

POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

sketchybar --add alias  "Control Center,WiFi" right                      \
           --rename     "Control Center,WiFi" wifi_alias                 \
           --set        wifi_alias    icon.drawing=off                   \
                                      alias.color="$YELLOW"              \
                                      background.padding_right=0         \
                                      icon.padding_right=0               \
                                      align=right                        \
                                      script="$PLUGIN_DIR/wifi.sh"       \
                                      click_script="$POPUP_CLICK_SCRIPT" \
           --subscribe  wifi_alias    mouse.entered                      \
                                      mouse.exited                       \
                                      mouse.exited.global                \
                                                                         \
            --add       item          wifi.template popup.wifi_alias     \
            --set                     wifi.template drawing=off          \
                                      background.corner_radius=12        \
                                      background.padding_left=7          \
                                      background.padding_right=7         \
                                      icon.background.height=2           \
                                      icon.background.y_offset=-12
