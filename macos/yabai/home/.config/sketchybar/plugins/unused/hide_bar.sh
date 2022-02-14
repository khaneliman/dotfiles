if [[ $(yabai -m query --spaces --space | grep "native-fullscreen") == *"0"* ]]; then
  sketchybar -m --bar hidden=off
else
  sketchybar -m --bar hidden=on
fi