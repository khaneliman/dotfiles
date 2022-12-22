#!/usr/bin/env sh
volume="$INFO"
bash "$HOME/.config/sketchybar/plugins/dynamic-island/scripts/queue_island.sh" \
   "volume;" \
   "1;$HOME/.config/sketchybar/plugins/dynamic-island/scripts/islands/volume/volume_island.sh $volume|;$HOME/.config/sketchybar/plugins/dynamic-island/scripts/islands/volume/reset.sh;0.8"
