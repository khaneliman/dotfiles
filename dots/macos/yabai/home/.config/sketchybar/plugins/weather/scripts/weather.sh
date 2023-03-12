#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

# False = night
# True = daytime
weather_icon_map() {
	case $@ in
	# Night
	"false Clear" | "false Mostly Clear")
		icon_result=""
		;;
	"false Mostly Cloudy" | "false Cloudy" | "false Partly Cloudy")
		icon_result=""
		;;
	"false Rain")
		icon_result=""
		;;
	"false Slight Chance Rain Showers" | "false Chance Rain Showers")
		icon_result=""
		;;
	"false Slight Chance Light Snow" | "false Chance Light Snow" | "false Snow Likely")
		icon_result=""
		;;
	"false Snow Showers" | "false Snow Showers Likely" | "false Chance Snow Showers" | "false Heavy Snow" | "false Snow and Patchy Blowing Snow")
		icon_result=""
		;;
	"false Patchy Fog" | "false Areas Of Fog" | "false Widespread Fog")
		icon_result=""
		;;
	# Daytime
	"true Slight Chance Light Rain" | "true Chance Light Rain")
		icon_result=""
		;;
	"true Rain Showers Likely" | "true Rain Showers" | "true Chance Rain Showers")
		icon_result=""
		;;
	"true Mostly Sunny" | "true Sunny")
		icon_result=""
		;;
	"true Partly Sunny")
		icon_result=""
		;;
	"true Cloudy")
		icon_result=""
		;;
	# No Match
	*)
		icon_result="N/A"
		;;
	esac
	echo $icon_result
}

render_bar() {
	args+=(--set weather.icon icon="$icon")
	args+=(--set weather.temp label="$temp""°")
}

render_popup() {
	args+=(--remove '/weather.details.\.*/')

	weather_details=(
		icon.drawing=off
		label="$popup"
		icon.color="$YELLOW"
		click_script="sketchybar --set $NAME popup.drawing=off"
		position=popup.weather.temp
		drawing=on
	)
	args+=(--clone weather.details.0 weather.details
		--set weather.details.0 "${weather_details[@]}")

	# TODO: Generate full weather report in popup
	# 	COUNTER=0
	#
	# 	if [ "$COUNT" -lt "$PREV_COUNT" ]; then
	# 		sketchybar -m --remove '/weather.details.\.*/'
	# 	fi
	#
	# 	while IFS= read -r line; do
	#   printf '%s\n' "$line"
	# done < output.txt
	#
	# 	while IFS= read -r line; do
	#
	# 		if [ "$COUNT" -gt "$PREV_COUNT" ]; then
	# 			sketchybar -m --add item weather.details."$COUNTER" popup."$NAME"
	# 		fi
	#
	# 		sketchybar -m --set weather.details."$COUNTER"     \
	# 			                  label="$(printf '%s\n' "$line")"  \
	# 			                  label.align=right           \
	# 			                  label.padding_left=20       \
	# 			                  icon="$COUNT : $PREV_COUNT" \
	# 			                  icon.drawing=off            \
	# 			                  click_script="sketchybar --set $NAME popup.drawing=off"
	# 		COUNTER=$((COUNTER + 1))
	#
	# 	done <<<"$(printf '%s' "$WEATHER")"
}

update() {
	args=()
	# Bar
	url=$(awk '/https/{print $0}' ~/weather_url)
	weather=$(curl -s "$url")
	temp=$(echo "$weather" | jq -r '.properties.periods[0].temperature')
	forecast=$(echo "$weather" | jq -r '.properties.periods[0].shortForecast')
	time=$(echo "$weather" | jq -r '.properties.periods[0].isDaytime')
	icon=$(weather_icon_map "$time" "$forecast")
	# popup
	location=$(cat ~/wttr_location)
	popup=$(curl -s "https://wttr.in/${location}?format=4" | sed 's/  */ /g')
	# icon=$(curl -s "$(echo "$weather" | jq -r '.poperties.periods[0].icon')")

	render_bar
	render_popup

	sketchybar -m "${args[@]}" >/dev/null

	if [ "$COUNT" -ne "$PREV_COUNT" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
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
