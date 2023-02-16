#!/usr/bin/env bash
SCRIPT_DIR="$(git rev-parse --show-toplevel)"
. "$SCRIPT_DIR"/scripts/utils/installer-helper.sh SETUP

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

	if [ -n "$FF_USER_PROFILE" ] && [ -n "$RELEASE_NAME" ]; then
		message "Firefox $RELEASE_NAME profile location:  $FF_USER_PROFILE"
	else
		error_message "Firefox profile not found!"
	fi
}
