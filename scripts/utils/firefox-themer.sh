#!/usr/bin/env bash

FF_USER_DIRECTORY=""
CHROME_DIRECTORY=""
RELEASE_NAME=""

print_help() {
	echo -e "firefox-themer: firefox-themer [-hp] [arguments]														\n\
	Copies a firefox chrome folder to a firefox profile.																\n\
																																											\n\
	Options: 																																						\n\
	 -help 			- Show this message 																										\n\
	 -profile <edition> 	- Check for profile path for specific edition 								\n\
	 -theme <edition> 	- Check for theme path 																					\n\
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
	 $ ./firefox-themer.sh stable blurredfox																						\n\
	 $ ./firefox-themer.sh dev  minimal																									\n\
																																											\n\
	Defaults to 'stable' if empty."
}

get_profile() {
	# Check args
	echo "${*}"
	echo "${1}"
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

	FF_USER_DIRECTORY="$(find "${HOME}/.mozilla/firefox/" -maxdepth 1 -type d -regextype egrep -regex '.*[a-zA-Z0-9]+.'"${EDITION}")"

	if [[ -n $EDITION ]]; then
		message "$FF_USER_DIRECTORY"
	fi
}

get_theme() {
	echo "${*}"
	echo "${1}"
	# Check args
	if [[ -n "${*}" ]] && [[ -n "${1}" ]]; then
		if [[ "${1}" == "blurredfox" ]]; then
			THEME="../../dots/shared/firefox-themes/blurredfox"
		elif [[ "${1}" == "minimal" ]]; then
			THEME="../../dots/shared/firefox-themes/minimal"
		else
			echo -ne "Invalid parameter!\n"
			print_help
			return
		fi
	else
		THEME="../../dots/shared/firefox-themes/minimal"
	fi

	THEME=$(readlink -f $THEME)

	if [[ -d $THEME ]]; then
		message "$THEME"
	fi
}

message() {
	printf "%s\n" "$*" >&2
}

install_theme() {
	get_profile "$1"
	get_theme "$2"

	if [[ -n "$FF_USER_DIRECTORY" ]]; then
		message "[>>] Firefox user profile directory located..."
		CHROME_DIRECTORY="$(find "$FF_USER_DIRECTORY/" -maxdepth 1 -type d -name 'chrome')"
		if [[ -n "$CHROME_DIRECTORY" ]]; then
			# Check if the chrome folder is not empty
			shopt -s nullglob dotglob
			content="${CHROME_DIRECTORY}/"

			# If there's a current theme, make a backup
			if [ ${#content[@]} -gt 0 ]; then
				message "[>>] Existing chrome folder detected! Creating a backup to chrome-backup/..."
				backup_dir="${CHROME_DIRECTORY}-backup"

				# Create backup folder
				if [[ ! -d "${backup_dir}" ]]; then
					message "[>>] chrome-backup/ folder does not exist! Creating..."
					mkdir "${backup_dir}"
				fi

				mv --backup=t "${CHROME_DIRECTORY}" "${backup_dir}"
				mkdir "${CHROME_DIRECTORY}"
			fi

			# copy theme directory to firefox chrome folder
			if [[ -d "$THEME" ]]; then
				cp -r "$THEME"/* "${FF_USER_DIRECTORY}/chrome"
			else
				message "[!!] Theme isn't a directory. Terminating..."
				return 1
			fi
		else
			message "[>>] Chrome folder does not exist! Creating one..."
			mkdir "${FF_USER_DIRECTORY}/chrome"

			# Check if backup folder exist
			if [[ $? -eq 0 ]]; then
				# copy theme directory to firefox chrome folder
				if [[ -d "$THEME" ]]; then
					cp -r "$THEME"/* "${FF_USER_DIRECTORY}/chrome"
				else
					message "[!!] Theme isn't a directory. Terminating..."
					return 1
				fi
			else
				message "[!!] There was a problem while creating the directory. Terminating..."
				return 1
			fi
		fi

	else
		message "[!!] No Firefox ${RELEASE_NAME} user profile detected! Make sure to run Firefox ${RELEASE_NAME} atleast once! Terminating..."
		return 1
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
		exit
		;;
	t)
		get_theme "$OPTARG"
		exit
		;;
	*) ;;
	esac
done
