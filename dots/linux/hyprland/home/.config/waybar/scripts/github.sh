#!/bin/bash

NOTIFICATIONS="$(gh api notifications)"
COUNT="$(echo "$NOTIFICATIONS" | jq 'length')"

echo '{"text":'"$COUNT"',"tooltip":"'"$COUNT"' Notifications","class":""}'
