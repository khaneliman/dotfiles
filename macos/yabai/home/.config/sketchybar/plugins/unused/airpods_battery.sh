DEVICES="$(system_profiler SPBluetoothDataType -json -detailLevel basic 2>/dev/null | jq '.SPBluetoothDataType' | jq '.[0]' | jq '.device_title' | jq -r '.[] | keys[] as $k | "\($k) \(.[$k] | .device_isconnected) \(.[$k] | .device_minorClassOfDevice_string)"' | grep 'attrib_Yes' | grep 'Headphones')"

if [ "$DEVICES" = "" ]; then
  sketchybar -m --set $NAME drawing=off
else
  sketchybar -m --set $NAME drawing=on
  # Left
  LEFT="$(defaults read /Library/Preferences/com.apple.Bluetooth | grep BatteryPercentLeft | tr -d \; | awk '{ printf("%02d", $3) }')"%

  # Right
  RIGHT="$(defaults read /Library/Preferences/com.apple.Bluetooth | grep BatteryPercentRight | tr -d \; | awk '{ printf("%02d", $3) }')"%

  # Case
  CASE="$(defaults read /Library/Preferences/com.apple.Bluetooth | grep BatteryPercentCase | tr -d \; | awk '{ printf("%02d", $3) }')"%

  echo $CASE

  if [ $LEFT = 00% ]; then
    LEFT="-"
  fi

  if [ $RIGHT = 00% ]; then
    RIGHT="-"
  fi

  if [ $CASE = 00% ]; then
    CASE="-"
  fi
  
  sketchybar -m --set $NAME label="$LEFT $CASE $RIGHT"
  echo "$LEFT $CASE $RIGHT"
fi