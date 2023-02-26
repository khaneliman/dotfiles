#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

update() {
	args=()
	# weather="$(wego)"
	url=$(awk  '/https/{print $0}' ~/weather_url)
	weather=$(curl -s $url)
	temp=$(echo "$weather" | jq -r '.properties.periods[0].temperature')
	forecast=$(echo "$weather" | jq -r '.properties.periods[0].shortForecast')
	time=$(echo "$weather" | jq -r '.properties.periods[0].isDaytime')
	icon=$("$HOME"/.config/sketchybar/plugins/icon_map.sh "$time $forecast")

	args+=(--set weather.icon icon="$icon")
	args+=(--set weather.temp label="$temp""°")

	args+=(--remove '/weather.event\.*/')

		args+=( --clone weather.event."$COUNTER" 	weather.details
						--set weather.event."$COUNTER"   	label="$forecast"
																						 	icon="$temp""°"
																						 	icon.color="$YELLOW"
																							click_script="sketchybar --set "$NAME" popup.drawing=off"
																							position=popup.weather.temp
																							drawing=on)

	sketchybar -m "${args[@]}" >/dev/null

	if [ "$SENDER" = "forced" ]; then
		sketchybar --animate tanh 15 --set "$NAME" label.y_offset=5 label.y_offset=0
	fi
}

popup() {
	sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
"routine" | "forced")
	update
	;;
"mouse.entered")
	popup on
	;;
"mouse.exited" | "mouse.exited.global")
	popup off
	;;
"mouse.clicked")
	popup toggle
	;;
esac
