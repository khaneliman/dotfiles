#!/usr/bin/env sh

sketchybar  --add       item            calendar.date right                   \
            --set       calendar.date   icon=date                             \
                                        icon.font="$FONT:Black:14.0"          \
                                        icon.align=right                      \
                                        width=30                              \
                                        y_offset=6                            \
                                        update_freq=120                       \
                                        script="$PLUGIN_DIR/date.sh"          \
                                        click_script="$PLUGIN_DIR/zen.sh"     \
            --subscribe                 calendar.date system_woke             \
                                                                              \
            --add       item            calendar.clock right                  \
            --set       calendar.clock  icon=clock                            \
                                        icon.font="$FONT:Bold:12.0"           \
                                        icon.align=right                      \
                                        background.padding_right=-20          \
                                        background.padding_left=0             \
                                        y_offset=-10                          \
                                        update_freq=15                        \
                                        script="$PLUGIN_DIR/clock.sh"         \
                                        click_script="$PLUGIN_DIR/zen.sh"     \
                                        label.padding_left=-50                \
            --subscribe                 calendar.clock system_woke            
                                                                              

