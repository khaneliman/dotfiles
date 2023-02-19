#!/usr/bin/env bash

stats_separator=(
	icon=
	icon.font="$NERD_FONT:Regular:16.0"
	background.padding_left=10
	background.padding_right=15
	label.drawing=off
	associated_display=active
	click_script='sketchybar --trigger toggle_stats'
	icon.color="$TEXT"
)

sketchybar  --add item stats_separator right \
	          --set stats_separator "${stats_separator[@]}"
