#!/usr/bin/env bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR"/scripts
DOTS_DIR="$SCRIPT_DIR"/dots
CONFIG_FILE="$SCRIPT_DIR"/setup.conf
source "scripts/utils/installer-helper.sh"

print_help() {
	echo -e "firefox-themer: firefox-themer [-hpt] [arguments]														\n\
	Installs a predefined theme to a specified firefox profile													\n\
																																											\n\
	Options: 																																						\n\
	 -help 			- Show this message 																										\n\
	 -profile <PROFILE> 	- Which firefox profile to install theme to 	 								\n\
	 -theme <THEME> 	- Theme to install 			 																					\n\
																																											\n\
	Arguments:																																					\n\
	 PROFILE	Profile to install theme in 																							\n\
	  stable	- Firefox Stable Build 																										\n\
	  dev 		- Firefox Developer Edition 																							\n\
	  beta 		- Firefox Beta 																														\n\
	  nightly 	- Firefox Nightly 																											\n\
	  esr 		- Firefox Extended Support Release 																				\n\
																																											\n\
	 THEME 		Theme folder to install 																									\n\
	  blurredfox 	- Transparent glass-like theme 																				\n\
	  minimal 	- Minimal theme with vertical tabs via Tab Center Reborn 								\n\
																																											\n\
	Example: 																																						\n\
	 $ ./firefox-themer.sh -p stable -t blurredfox																			\n\
	 $ ./firefox-themer.sh -d dev -m minimal																						\n\
																																											\n\
	Defaults to 'stable' if empty."
}

get_profile() {
	# Check args
	if [[ -n "${*}" ]] && [[ -n "${1}" ]]; then
		if [[ "${1}" == "dev" ]]; then
			RELEASE_NAME="Developer Edition"
			EDITION="dev-edition-default"
		elif [[ "${1}" == "beta" ]]; then
			RELEASE_NAME="Beta"
			EDITION="default-beta"
		elif [[ "${1}" == "nightly" ]]; then
			RELEASE_NAME="Nightly"
			EDITION="default-nightly"
		elif [[ "${1}" == "stable" ]]; then
			RELEASE_NAME="Stable"
			EDITION="default-release"
		elif [[ "${1}" == "esr" ]]; then
			RELEASE_NAME="ESR"
			EDITION="default-esr"
		else
			echo -ne "Invalid parameter!\n"
			print_help
			return
		fi
	else
		RELEASE_NAME="Stable"
		EDITION="default-release"
	fi

	case "$(uname)" in
	"Linux")
		FF_USER_CONFIG="${HOME}/.mozilla/firefox/"
		FF_USER_PROFILE="$(find "$FF_USER_CONFIG" -maxdepth 1 -type d -regextype egrep -regex '.*[a-zA-Z0-9]+.'"${EDITION}")"
		;;
	"Darwin")
		FF_USER_CONFIG="${HOME}/Library/Application Support/Firefox/Profiles/"
		FF_USER_PROFILE="$(gfind "$FF_USER_CONFIG" -maxdepth 1 -type d -regextype egrep -regex '.*[a-zA-Z0-9]+.'"${EDITION}")"
		;;
	esac

	if [[ -n $EDITION ]]; then
		message "Firefox profile location:  $FF_USER_PROFILE"
	fi
}

get_theme() {
	# Check args
	if [[ -n "${*}" ]] && [[ -n "${1}" ]]; then
		if [[ "${1}" == "blurredfox" ]]; then
			THEME="$DOTS_DIR/shared/firefox-themes/blurredfox"
		elif [[ "${1}" == "minimal" ]]; then
			THEME="$DOTS_DIR/shared/firefox-themes/minimal"
		else
			error_message "Invalid parameter!\n"
			print_help
			return
		fi
	else
		THEME="$DOTS_DIR/shared/firefox-themes/minimal"
		warning_message "No theme provided. Falling back to $THEME"
	fi

	THEME=$(readlink -f "$THEME")

	if [[ -d $THEME ]]; then
		message "Theme location:  $THEME"
	fi
}

install_theme() {
	if [[ ! -d $FF_USER_PROFILE ]]; then
		get_profile
	fi

	if [[ ! -d $THEME ]]; then
		get_theme
	fi

	if [[ -n "$FF_USER_PROFILE" ]]; then
		message "Firefox user profile directory located..."
		CHROME_DIRECTORY="$(find "$FF_USER_PROFILE/" -maxdepth 1 -type d -name 'chrome')"
		if [[ -n "$CHROME_DIRECTORY" ]]; then
			# Check if the chrome folder is not empty
			shopt -s nullglob dotglob
			content="${CHROME_DIRECTORY}/"

			# If there's a current theme, make a backup
			if [ ${#content[@]} -gt 0 ]; then
				message "Existing chrome folder detected! Creating a backup to chrome-backup/..."
				backup_dir="${CHROME_DIRECTORY}-backup"

				# Create backup folder
				if [[ ! -d "${backup_dir}" ]]; then
					message "chrome-backup/ folder does not exist! Creating..."
					mkdir "${backup_dir}"
				fi

				backup_files "${CHROME_DIRECTORY}" "${backup_dir}"
			fi

			# copy theme directory to firefox chrome folder
			if [[ -d "$THEME" ]]; then
				message "Theme found! copying files..."
				replace_files "$THEME" "${FF_USER_PROFILE}/chrome"
				copy_files "$THEME/../user.js" "${FF_USER_PROFILE}/"
				success_message "Installed theme successfully."
			else
				error_message "Theme isn't a directory. Terminating..."
				exit 1
			fi
		else
			message "Chrome folder does not exist! Creating one..."
			mkdir "${FF_USER_PROFILE}/chrome"

			# Check if backup folder exist
			if [[ $? -eq 0 ]]; then
				# copy theme directory to firefox chrome folder
				if [[ -d "$THEME" ]]; then
					message "Theme found! copying files..."
					replace_files "$THEME" "${FF_USER_PROFILE}/chrome"
					copy_files "$THEME/../user.js" "${FF_USER_PROFILE}/"
					success_message "Installed theme successfully."
				else
					error_message "Theme isn't a directory. Terminating..."
					exit 1
				fi
			else
				error_message "There was a problem while creating the directory. Terminating..."
				exit 1
			fi
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
	t)
		get_theme "$OPTARG"
		;;
	*) ;;
	esac
done

install_theme
