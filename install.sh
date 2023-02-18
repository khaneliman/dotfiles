#!/usr/bin/env bash

. ./scripts/utils/installer-helper.sh SETUP

if [ ! "$?" -eq 0 ]; then
	echo "Couldn't source required files. Exiting."
	exit
fi

[ -f "$CONFIG_FILE" ] || touch -f "$CONFIG_FILE"

# Delete existing log file and log output of script
[[ -f "$LOG_FILE" ]] && rm -f "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1

logo

# Install shared first in case specific overrides it
shared_install

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	message "Linux detected..."

	linux_install

elif [[ "$OSTYPE" == "darwin"* ]]; then
	message "Mac detected..."

	mac_install

elif [[ "$OSTYPE" == "win32" ]]; then
	error_message "Run the install.bat script instead..."

else
	error_message "unsupported os... exiting"
fi
