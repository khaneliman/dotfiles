#!/usr/bin/env bash

hide_stats() {
sketchybar 		--set cpu.percent 									\
  															label.drawing=off \
  															icon.drawing=off  \
  						--set memory 												\
  															label.drawing=off \
  															icon.drawing=off  \
  						--set disk 													\
																label.drawing=off \
  															icon.drawing=off  \
  						--set stats_separator 							\
  															icon=

                   
}

show_stats() {
  sketchybar 	--set cpu.percent 									\
  															label.drawing=on 	\
  															icon.drawing=on  	\
  						--set memory 												\
  															label.drawing=on 	\
  															icon.drawing=on  	\
  						--set disk 													\
																label.drawing=on 	\
  															icon.drawing=on  	\
  						--set stats_separator 							\
  															icon=
}

toggle_stats() {
	state=$(sketchybar --query stats_separator | jq -r .icon.value)
	
	case $state in
		"") show_stats
			;;
		"") hide_stats
			;;
	esac
}

case "$SENDER" in
  "hide_stats") hide_stats
  ;;
  "show_stats") show_stats
  ;;
	"toggle_stats") toggle_stats
	;;
esac
