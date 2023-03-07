#!/usr/bin/env bash
#
# ░█▀▀░▀█▀░█▀▄░█▀▀░█▀▀░█▀█░█░█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
# ░█▀▀░░█░░█▀▄░█▀▀░█▀▀░█░█░▄▀▄░░░█░░░█░█░█░█░█▀▀░░█░░█░█
# ░▀░░░▀▀▀░▀░▀░▀▀▀░▀░░░▀▀▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀SCRIPT_DIR="$(git rev-parse --show-toplevel)"
#
SCRIPTS_DIR="$SCRIPT_DIR"/scripts
DOTS_DIR="$SCRIPT_DIR"/dots

. $SCRIPTS_DIR/utils/installer-helper.sh SETUP
. "$SCRIPTS_DIR"/firefox/firefox-shared.sh

print_help() {
	echo -e "	firefox-config: firefox-config [-hpt] [arguments]													\n\
																																											\n\
	Installs entire config to a specified firefox profile																\n\
																																											\n\
	Options: 																																						\n\
	 -h | -help 	- Show this message 																									\n\
	 -p <PROFILE> 	- Which firefox profile to install config to 	 											\n\
																																											\n\
	Arguments:																																					\n\
	 PROFILE	Profile to install config in 																							\n\
	  stable	- Firefox Stable Build 																										\n\
	  dev 		- Firefox Developer Edition 																							\n\
	  beta 		- Firefox Beta 																														\n\
	  nightly 	- Firefox Nightly 																											\n\
	  esr 		- Firefox Extended Support Release 																				\n\
																																											\n\
	Example: 																																						\n\
	 $ ./firefox-config.sh -p stable																										\n\
	 $ ./firefox-config.sh -p dev																												\n\
																																											\n\
	Defaults to 'stable' if empty."
}

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
