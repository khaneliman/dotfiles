#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

PAIRED="$(blueutil --paired)"
CONNECTED="$(blueutil --connected)"
COUNT_PAIRED="$(echo "$PAIRED" | grep "^.*$" -c)"
COUNT_CONNECTED="$(echo "$CONNECTED" | grep "^.*$" -c)"

render_bar_item() {
  if [ "$PAIRED" = "" ]; then
    args+=(--set "$NAME" label.drawing=off)
  else
    args+=(--set "$NAME" label="$COUNT_PAIRED" label.drawing=off)
  fi
}

render_popup() {
  args+=(                                          \
         --set  bluetooth.details                                                              \
                                            label="$(echo -e 'Paired Devices')"                       \
                                            label.padding_right="$PADDING"                            \
                                            icon.drawing=off \
                                            click_script="sketchybar --set $NAME popup.drawing=off")


  COUNTER=0
  
  while read -r device 
  do

    COUNTER=$((COUNTER + 1))
    PADDING=0
  
    # if [ "$COUNT_PAIRED" -ne "$PREV_COUNT" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
      args+=(--remove '/bluetooth.notification\.*/')
      args+=(--clone  bluetooth.notification."$COUNTER" bluetooth.details)
    # fi
    
    args+=(--set    bluetooth.notification."$COUNTER"                                                   \
                                            label="$(echo "$device" | grep -Eo '".*."')"                \
                                            label.padding_right=0                                       \
                                            position=popup."$NAME"                                      \
                                            label.align=left                                            \
                                            icon="$COUNT_PAIRED : $PREV_COUNT"                          \
                                            icon.drawing=off                                             \
                                            click_script="sketchybar --set $NAME popup.drawing=off")
	done <<<"$(echo -e "$PAIRED")"


  sketchybar -m "${args[@]}" > /dev/null
}

update() {
  args=()

  PREV_COUNT=$(sketchybar --query "$NAME" | jq -r .label.value)

  render_bar_item
  render_popup

  
  if [ "$COUNT_PAIRED" -gt "$PREV_COUNT" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
    sketchybar --animate tanh 15 --set "$NAME" label.y_offset=5 label.y_offset=0
  fi
}

popup() {
  sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
  "routine"|"forced") update
  ;;
  "mouse.entered") popup on
  ;;
  "mouse.exited"|"mouse.exited.global") popup off
  ;;
  "mouse.clicked") popup toggle
  ;;
esac
