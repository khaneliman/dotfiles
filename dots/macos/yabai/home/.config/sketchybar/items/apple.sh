#!/usr/bin/env sh

POPUP_OFF="sketchybar --set apple.logo popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

sketchybar --add item           apple.logo left                             \
           --set apple.logo     icon="$APPLE"                               \
                                icon.font="$FONT:Black:16.0"                \
                                icon.color="$BLUE"                          \
                                background.padding_right=15                 \
                                label.drawing=off                           \
                                click_script="$POPUP_CLICK_SCRIPT"          \
                                popup.height=30                             \
                                                                            \
           --add item           apple.prefs popup.apple.logo                \
           --set apple.prefs    icon="$PREFERENCES"                         \
                                label="Preferences"                         \
                                click_script="open -a 'System Preferences';
                                              $POPUP_OFF"                   \
                                                                            \
           --add item           apple.activity popup.apple.logo             \
           --set apple.activity icon="$ACTIVITY"                            \
                                label="Activity"                            \
                                click_script="kitty --single-instance -e btop;
                                              $POPUP_OFF"                   \
                                                                            \
           --add item           apple.lock popup.apple.logo                 \
           --set apple.lock     icon="$LOCK"                                \
                                label="Lock Screen"                         \
                                click_script="osascript -e 'tell application \
                                            \"System Events\" to keystroke \"q\" \
                                              using {command down,control down}';
                                              $POPUP_OFF"                   \
           --add item           apple.separator popup.apple.logo            \
           --set apple.separator icon.drawing=off \
                                label="----------------" \
                                                                            \
           --add item           apple.sleep popup.apple.logo                \
           --set apple.sleep   icon="$SLEEP"                                \
                                icon.padding_left=5                         \
                                label="Sleep"                               \
                                click_script="osascript -e 'tell app \"System Events\" to sleep';
                                              $POPUP_OFF"                   \
           --add item           apple.reboot popup.apple.logo               \
           --set apple.reboot   icon="$REBOOT"                              \
                                icon.padding_left=5                         \
                                label="Reboot"                              \
                                click_script="osascript -e 'tell app \"loginwindow\" to «event aevtrrst»';
                                              $POPUP_OFF"                   \
           --add item           apple.shutdown popup.apple.logo             \
           --set apple.shutdown icon="$POWER"                               \
                                icon.padding_left=5                         \
                                label="Shutdown"                            \
                                click_script="osascript -e 'tell app \"loginwindow\" to «event aevtrsdn»';
                                              $POPUP_OFF"
