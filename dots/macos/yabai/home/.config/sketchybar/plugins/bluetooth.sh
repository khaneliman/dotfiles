#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

PAIRED="$(blueutil --paired)"
CONNECTED="$(blueutil --connected)"

update() {
  
  COUNT="$("$CONNECTED" | grep "^.*$" -c)"
  args=()
  if [ "$CONNECTED" = "" ]; then
    args+=(--set "$NAME" label.drawing=off)
  else
    args+=(--set "$NAME" label="$COUNT" label.drawing=on)
  fi

  PREV_COUNT=$(sketchybar --query "$NAME" | jq -r .label.value)
  
  args+=(--remove '/bluetooth.notification\.*/')

  args+=(--clone bluetooth.notification.0 bluetooth.template                                          \
         --set  bluetooth.notification.0                                                              \
                                            label="$(echo -e 'Paired Devices')"                       \
                                            label.padding_right="$PADDING"                            \
                                            position=popup."$NAME"                                    \
                                            drawing=on                                                \
                                            click_script="sketchybar --set $NAME popup.drawing=off")


  COUNTER=1
  
  while read -r device 
  do
    COUNTER=$((COUNTER + 1))
    PADDING=0
    
    args+=(--clone  bluetooth.notification."$COUNTER" bluetooth.template                                \
           --set    bluetooth.notification."$COUNTER"                                                   \
                                            label="$(echo "$device" | grep -Eo '".*."')"                \
                                            label.padding_right="$PADDING"                              \
                                            position=popup."$NAME"                                      \
                                            drawing=on                                                  \
                                            click_script="sketchybar --set $NAME popup.drawing=off")
	done <<<"$(echo -e "$PAIRED")"


  sketchybar -m "${args[@]}" > /dev/null

  if [ "$COUNT" -gt "$PREV_COUNT" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
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
