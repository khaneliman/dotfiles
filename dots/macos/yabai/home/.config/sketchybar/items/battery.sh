#!/usr/bin/env sh
sketchybar -m --add item    battery right 																		\
              --set battery update_freq=10 																		\
                            script="$PLUGIN_DIR/battery.sh" 	                \
