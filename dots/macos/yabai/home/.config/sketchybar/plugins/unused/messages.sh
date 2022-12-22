TEXT=$(sqlite3 ~/Library/Messages/chat.db "SELECT text FROM message WHERE is_read=0 AND is_from_me=0 AND text!='' AND date_read=0" | wc -l | awk '{$1=$1};1')

if [ $TEXT = 0 ]; then
  sketchybar -m --set messages drawing=off
else
  sketchybar -m --set messages drawing=on
  sketchybar -m --set messages label="$TEXT"
  echo "$TEXT"
fi