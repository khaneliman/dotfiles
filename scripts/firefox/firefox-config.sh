#!/usr/bin/env bash

SCRIPT_DIR="$(git rev-parse --show-toplevel)"
SCRIPTS_DIR="$SCRIPT_DIR"/scripts
DOTS_DIR="$SCRIPT_DIR"/dots

. $SCRIPTS_DIR/utils/installer-helper.sh SETUP
. "$SCRIPTS_DIR"/firefox/firefox-shared.sh

install_config() {
	if [[ ! -d $FF_USER_PROFILE ]]; then
		get_profile
	fi

	if [[ -n "$FF_USER_PROFILE" ]]; then
		message "Firefox user profile directory located..."
		backup_dir="${FF_USER_PROFILE}-backup"

		# Create backup folder
		if [[ ! -d "${backup_dir}" ]]; then
			message "Profile backup folder does not exist! Creating..."
			mkdir "${backup_dir}"
		fi

		backup_files "${FF_USER_PROFILE}"/ "${backup_dir}"

		if [[ $? -eq 0 ]]; then
			copy_files "$DOTS_DIR"/shared/home/.mozilla/firefox/khaneliman.default/ "${FF_USER_PROFILE}"
			success_message "Installed firefox config"
		else
			error_message "Couldn't backup existing profile. Skipping installation."
		fi
	else
		error_message "No Firefox ${RELEASE_NAME} user profile detected! Make sure to run Firefox ${RELEASE_NAME} atleast once! Terminating..."
		exit 1
	fi
}

# Get the options
while getopts ":hp:t:" option; do
	case "$option" in
	h) # display Help
		print_help
		exit
		;;
	p)
		get_profile "$OPTARG"
		;;
	*) ;;
	esac
done

install_config
