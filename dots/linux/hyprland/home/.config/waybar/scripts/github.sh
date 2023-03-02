#!/bin/bash

NOTIFICATIONS="$(gh api notifications)"
COUNT="$(echo "$NOTIFICATIONS" | jq 'length')"

if [[ "$COUNT" != "0" ]]; then
	echo '{"text":'"$COUNT"',"tooltip":"'"$COUNT"' Notifications","class":""}'
fi
