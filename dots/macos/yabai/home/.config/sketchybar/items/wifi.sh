#!/usr/bin/env sh

POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

sketchybar --add alias  "Control Center,WiFi" right                      \
           --rename     "Control Center,WiFi" wifi.alias                 \
           --set        wifi.alias    icon.drawing=off                   \
                                      alias.color="$YELLOW"              \
                                      background.padding_right=0         \
                                      icon.padding_right=0               \
                                      align=right                        \
                                      click_script="$POPUP_CLICK_SCRIPT" \
                                      script="$PLUGIN_DIR/wifi.sh"       \
                                      update_freq=1                      \
           --subscribe  wifi.alias    mouse.entered                      \
                                      mouse.exited                       \
                                      mouse.exited.global                \
                                                                         \
            --add       item          wifi.details popup.wifi.alias      \
            --set       wifi.details  background.corner_radius=12        \
                                      background.padding_left=7          \
                                      background.padding_right=7         \
                                      icon.background.height=2           \
                                      icon.background.y_offset=-12       \
                                      click_script="sketchybar --set wifi.alias popup.drawing=off"
