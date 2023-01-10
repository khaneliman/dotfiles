#!/usr/bin/env bash

# Find the name of the folder the scripts are in
set -a # mark variables to be exported to subsequent commands

CURRENT_TIME=$(date "+%Y.%m.%d-%H.%M.%S")
BACKUP_LOCATION="$HOME/.dotfiles-backup/$CURRENT_TIME/"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR"/scripts
DOTS_DIR="$SCRIPT_DIR"/dots
CONFIG_FILE="$SCRIPT_DIR"/setup.conf
LOG_FILE="$SCRIPT_DIR"/install.log

[ -f "$CONFIG_FILE" ] || touch -f "$CONFIG_FILE"

# Colors/formatting for echo
BOLD='\e[1m'
RESET='\e[0m' # Reset text to default appearance
#   High intensity colors:
BRED='\e[91m'

set +a

# Source all scripts
for filename in "$SCRIPTS_DIR"/**/*.sh "$SCRIPTS_DIR"/shared.sh; do
	[ -e "$filename" ] || continue
	source "$filename"
done

logo

# Install shared first in case specific overrides it
shared_install

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo 'linux detected... running install for linux'

	linux_install

elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo 'mac detected... running install for mac'

	mac_install

elif [[ "$OSTYPE" == "win32" ]]; then
	echo 'windows detected... running install for windows'

	windows_install

else
	echo 'unsupported os... exiting'
fi
