#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

BATT_PERCENT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

render_bar_item() {
        sketchybar --set "${NAME}" icon.color=0xff989898

        if [[ ${CHARGING} != "" ]]; then
            case ${BATT_PERCENT} in
                100) ICON="" COLOR="$GREEN" ;;
                9[0-9]) ICON="" COLOR="$GREEN" ;;
                8[0-9]) ICON="" COLOR="$GREEN" ;;
                7[0-9]) ICON="" COLOR="$GREEN" ;;
                6[0-9]) ICON="" COLOR="$YELLOW" ;;
                5[0-9]) ICON="" COLOR="$YELLOW" ;;
                4[0-9]) ICON="" COLOR="$PEACH" ;;
                3[0-9]) ICON="" COLOR="$PEACH" ;;
                2[0-9]) ICON="" COLOR="$RED" ;;
                1[0-9]) ICON="" COLOR="$RED" ;;
                *) ICON=""  COLOR="$RED" ;;
            esac

          sketchybar --set "${NAME}" icon="${ICON}" icon.color="${COLOR}"
          sketchybar --set "${NAME}" label="${BATT_PERCENT}%"
          exit 0
        fi

        case ${BATT_PERCENT} in
            100) ICON="" COLOR="$GREEN" ;;
            9[0-9]) ICON="" COLOR="$GREEN" ;;
            8[0-9]) ICON="" COLOR="$GREEN" ;;
            7[0-9]) ICON="" COLOR="$GREEN" ;;
            6[0-9]) ICON="" COLOR="$YELLOW" ;;
            5[0-9]) ICON="" COLOR="$YELLOW" ;;
            4[0-9]) ICON="" COLOR="$PEACH" ;;
            3[0-9]) ICON="" COLOR="$PEACH" ;;
            2[0-9]) ICON="" COLOR="$RED" ;;
            1[0-9]) ICON="" COLOR="$RED" ;;
            *) ICON=""  COLOR="$RED" ;;
        esac

        sketchybar --set "${NAME}" icon="${ICON}" icon.color="${COLOR}"
        # sketchybar --set "${NAME}" label="${BATT_PERCENT}%" # uncomment if you want to always see the percent remaining
}

render_popup() {
        args+=(--remove '/battery.notification\.*/')

        args+=( --clone battery.notification.0 battery.template                                         \
                --set  battery.notification.0                                                           \
                                            label="${BATT_PERCENT}%"                                    \
                                            label.padding_right=0                                       \
                                            position=popup."$NAME"                                      \
                                            drawing=on                                                  \
                                            click_script="sketchybar --set $NAME popup.drawing=off")

        sketchybar -m "${args[@]}" > /dev/null
}

update() {
        render_bar_item
        render_popup
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
