#!/usr/bin/env bash

# Find the name of the folder the scripts are in
set -a # mark variables to be exported to subsequent commands

CURRENT_TIME=$(date "+%Y.%m.%d-%H.%M.%S")
BACKUP_LOCATION="$HOME/.dotfiles-backup/$CURRENT_TIME"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR"/scripts
DOTS_DIR="$SCRIPT_DIR"/dots
CONFIG_FILE="$SCRIPT_DIR"/setup.conf
LOG_FILE="$SCRIPT_DIR"/install.log

GIT_CRYPT_LOCKED=$(test -z "$(git config --local --get filter.git-crypt.smudge 2>/dev/null)" && echo "True" || echo "False")

[ -f "$CONFIG_FILE" ] || touch -f "$CONFIG_FILE"

# Colors/formatting for echo
BOLD='\e[1m'
RESET='\e[0m' # Reset text to default appearance
#   High intensity colors:
BRED='\e[91m'

set +a

# Delete existing log file and log output of script
[[ -f "$LOG_FILE" ]] && rm -f "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1

# Source all scripts
for filename in "$SCRIPTS_DIR"/**/*.sh "$SCRIPTS_DIR"/shared.sh; do
	[ -e "$filename" ] || continue
	source "$filename"
done

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
