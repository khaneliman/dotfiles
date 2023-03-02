#!/bin/bash

PACKAGES="$(checkupdates)"
COUNT="$(echo "$PACKAGES" | wc -l)"

echo '{"text":'"$COUNT"',"tooltip":"'"$PACKAGES"'","class":""}'
