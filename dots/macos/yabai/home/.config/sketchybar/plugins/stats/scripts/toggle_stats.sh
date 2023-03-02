#!/usr/bin/env bash

hide_stats() {
	sketchybar --set cpu.percent \
										label.drawing=off \
										icon.drawing=off \
							--set memory \
										label.drawing=off \
										icon.drawing=off \
							--set disk \
										label.drawing=off \
										icon.drawing=off \
							--set separator_right \
										icon=

}

show_stats() {
	sketchybar 	--set cpu.percent \
										label.drawing=on \
										icon.drawing=on \
							--set memory \
										label.drawing=on \
										icon.drawing=on \
							--set disk \
										label.drawing=on \
										icon.drawing=on \
							--set separator_right \
										icon=
}

toggle_stats() {
	state=$(sketchybar --query separator_right | jq -r .icon.value)

	case $state in
	"")
		show_stats
		;;
	"")
		hide_stats
		;;
	esac
}

case "$SENDER" in
"hide_stats")
	hide_stats
	;;
"show_stats")
	show_stats
	;;
"toggle_stats")
	toggle_stats
	;;
esac
