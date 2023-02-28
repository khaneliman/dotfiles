#! /usr/bin/env bash

LOCKFILE="${TMPDIR}/yabai_update.lock"
if [ -e "$LOCKFILE" ] && kill -0 "$(cat "$LOCKFILE")"; then
	echo "Update already in progress"
	exit
fi

trap 'rm -f ${LOCKFILE}; exit' INT TERM EXIT
echo "$$" >"$LOCKFILE"

function check_for_updates() {
	set -o pipefail

	# avoid GitHub rate limitations when jq is installed by using the GitHub
	# API instead of ls-remote
	if command -v jq >/dev/null 2>&1; then
		installed="$(brew info --json yabai |
			jq -r '.[0].installed[0].version')"
		remote="$(curl -fsSL "https://api.github.com/repos/koekeishiya/yabai/commits" |
			jq -r '"HEAD-" + (.[0].sha | explode | .[0:7] | implode)')"
	else
		installed="$(brew info yabai | grep 'HEAD-' |
			awk '{print substr($1,length($1)-6)}')"
		remote="$(git ls-remote 'https://github.com/koekeishiya/yabai.git' HEAD |
			awk '{print substr($1,1,7)}')"
	fi

	[ "${?}" -eq 0 ] && [[ "$installed" != "$remote" ]]
}

function install_updates() {

	echo "[yabai-update] reinstalling yabai"
	brew reinstall yabai >/dev/null 2>&1

	echo "[yabai-update] codesigning yabai"
	codesign -fs "${1:-yabai-sign}" "$(brew --prefix yabai)/bin/yabai" >/dev/null

	new_sha="$(shasum -a 256 "$(which yabai)" | grep -E -o '[A-Fa-f0-9]{64}')"

	echo "[yabai-update] checking installed scripting addition"
	if yabai --check-sa; then
		osascript >/dev/null <<-EOM
			display dialog "A new version of yabai was just installed and yabai will restart shortly." with title "$(yabai --version)" buttons {"Okay"} default button 1
		EOM
	else
		echo "[yabai-update] prompting to reinstall scripting addition"
		script="$(mktemp)"
		cat >"$script" <<-EOF
			#! /usr/bin/env sh
			sudo yabai --uninstall-sa
			sudo yabai --install-sa
			sudo gsed -i "s/sha256:[A-Fa-f0-9]\{64\} \/opt\/homebrew\/bin\/yabai --load-sa/sha256:${new_sha} \/opt\/homebrew\/bin\/yabai --load-sa/"  /private/etc/sudoers.d/yabai
			pkill -x Dock
		EOF
		chmod +x "$script"
		osascript >/dev/null <<-EOM
			display dialog "A new version of yabai was just installed and yabai will restart shortly.\n\nDo you want to reinstall the scripting addition (osascript will prompt for elevated privileges)?" with title "$(yabai --version)" buttons {"Install", "Cancel"} default button 2
			if button returned of result = "Install" then
				do shell script "${script}" with administrator privileges
			end if
		EOM
		rm -f "$script"
	fi

	echo "[yabai-update] restarting yabai"
	launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"
}

if check_for_updates; then
	install_updates "$YABAI_CERT"
fi

rm -f "$LOCKFILE"
