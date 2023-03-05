#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/userconfig.sh" # Loads all defined icons

render_bar_item() {
	case "$COUNT" in
	[3-5][0-9])
		COLOR=$PEACH
		;;
	[1-2][0-9])
		COLOR=$YELLOW
		;;
	[1-9])
		COLOR=$TEXT
		;;
	0)
		COLOR=$GREEN
		COUNT=􀆅
		;;
	esac

	sketchybar --set "$NAME" label="$COUNT" icon.color="$COLOR"
}

add_outdated_header() {
	sketchybar -m --set brew.details                        \
		                  label="$(echo -e 'Outdated Brews')" \
		                  label.font="$FONT:Bold:14.0"        \
		                  label.align=left                    \
		                  icon.drawing=off                    \
		                  click_script="sketchybar --set $NAME popup.drawing=off"
}

render_popup() {
	add_outdated_header

	COUNTER=0
	sketchybar -m --remove '/brew.package\.*/'

	if [[ -n "$OUTDATED" ]]; then
		while IFS= read -r package; do

			sketchybar -m --add item brew.package."$COUNTER"\
													popup."$NAME"               \
			                  	label="$(echo "$package")"  \
			                  	label.align=right           \
			                  	label.padding_left=20       \
			                  	icon="$COUNT : $PREV_COUNT" \
			                  	icon.drawing=off            \
			                  	click_script="sketchybar --set $NAME popup.drawing=off"
			COUNTER=$((COUNTER + 1))

		done <<<"$(echo -n "$OUTDATED" | grep '^')"
	fi
}

update() {
	"$(brew update)"
	COLOR=$RED
	OUTDATED=$(brew outdated)
	COUNT=$(echo -n "$OUTDATED" | grep -c '^')

	PREV_COUNT=$(sketchybar --query brew | jq -r .popup.items | grep ".package*" -c)

	render_bar_item
	render_popup

	if [ "$COUNT" -ne "$PREV_COUNT" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
		sketchybar --animate tanh 15 --set "$NAME" label.y_offset=5 label.y_offset=0
	fi
}

popup() {
	PREV_COUNT=$(sketchybar --query brew | jq -r .popup.items | grep ".package*" -c)
	
	if [[ "$PREV_COUNT" -gt 0 ]]; then         
    sketchybar --set "$NAME" popup.drawing="$1"
  else 
    sketchybar --set "$NAME" popup.drawing=off
  fi

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
