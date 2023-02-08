#!/usr/bin/env bash
#github-action genshdoc
#
# @file Installer Helper
# @brief Contains the functions used to facilitate the installer
# @stdout Output routed to install.log
# @stderror Output routed to install.log

# @description Backup the given file/folder to a provided destination
# @arg $1 Source file/folder
# @arg $2 Destination folder
backup_files() {
	if [ -f "$1" ] || [ -d "$1" ]; then
		if [ -d "$2" ]; then
			message "Backing up a copy of $1 to $2"
			cp -r "$1" "$2"
			success_message "Successfully backed up $1"
		else
			warning_message "$2 doesn't exist. Creating destination..."
			mkdir -p "$2"
			cp -r "$1" "$2"
			success_message "Successfully backed up $1"
		fi
	else
		warning_message "$1 doesn't exist. Skipping backup..."
	fi
}

cecho() {
	RED="\033[0;31m"
	GREEN="\033[0;32m"  # <-- [0 means not bold
	YELLOW="\033[1;33m" # <-- [1 means bold
	CYAN="\033[1;36m"
	# ... Add more colors if you like

	NC="\033[0m" # No Color

	# printf "${(P)1}${2} ${NC}\n" # <-- zsh
	printf "${!1}${2} ${NC}\n" # <-- bash
}

# @description Copy files from the given file/folder to a provided destination without replacing entirely
# @arg $1 Source file/folder
# @arg $2 Destination file/folder
copy_files() {
	if [[ -L "$2" && -e "$2" ]]; then
		warning_message "Valid symlink already exists at $2. Skipping..."
		warning_message "If you would like to recreate, delete existing link and rerun."
	else
		message "Copying from $1 at $2..."
		cp -r "$1" "$2"
		success_message "Successfully copied $1 to $2"
	fi
}

# @description Copy logs to installed system and exit script
# @noargs
end() {
	echo "Copying logs"
	if [[ "$(find /mnt/var/log -type d | wc -l)" -ne 0 ]]; then
		cp -v "$LOG_FILE" /mnt/var/log/install.log
	else
		echo -ne "ERROR! Log directory not found"
		exit 0
	fi
}

error_message() {
	cecho "RED" "[!!] $1"
}

# @description Exits script if previous command fails
# @arg $1 string Exit code of previous command
# @arg $2 string Previous command
exit_on_error() {
	exit_code=$1
	last_command=${*:2}
	if [ "$exit_code" -ne 0 ]; then
		echo >&2 "\"${last_command}\" command failed with exit code ${exit_code}."
		exit "$exit_code"
	fi
}

# @description Select multiple options
# @noargs
function multiselect {

	# little helpers for terminal print control and key input
	ESC=$(printf "\033")
	cursor_blink_on() { printf "%s[?25h" "$ESC"; }
	cursor_blink_off() { printf "%s[?25l" "$ESC"; }
	cursor_to() { printf "%s[$1;${2:-1}H" "$ESC"; }
	print_inactive() { printf "%s   %s " "$2" "$1"; }
	print_active() { printf "$2  %s[7m $1 %s[27m" "$ESC" "$ESC"; }
	get_cursor_row() {
		IFS=';' read -rsdR -p $'\E[6n' ROW COL
		echo "${ROW#*[}"
	}
	get_cursor_col() {
		IFS=';' read -rsdR -p $'\E[6n' ROW COL
		echo "${COL#*[}"
	}
	key_input() {
		local key
		IFS= read -rsn1 key 2>/dev/null >&2
		if [[ $key = "" ]]; then echo enter; fi
		if [[ $key = $'\x20' ]]; then echo space; fi
		if [[ $key = $'\x1b' ]]; then
			read -rsn2 key
			if [[ $key = [A ]]; then echo up; fi
			if [[ $key = [B ]]; then echo down; fi
		fi
	}
	toggle_option() {
		local arr_name=$1
		eval "local arr=(\"\${${arr_name}[@]}\")"
		local option=$2
		if [[ ${arr[option]} == true ]]; then
			arr[option]=
		else
			arr[option]=true
		fi
		eval "$arr_name"='("${arr[@]}")'
	}

	local retval=$1
	local options
	local defaults

	IFS=';' read -r -a options <<<"$2"
	if [[ -z $3 ]]; then
		defaults=()
	else
		IFS=';' read -r -a defaults <<<"$3"
	fi
	local selected=()

	for ((i = 0; i < ${#options[@]}; i++)); do
		selected+=("${defaults[i]}")
		printf "\n"
	done

	# determine current screen position for overwriting the options
	local lastrow=$(get_cursor_row)
	local startrow=$((lastrow - ${#options[@]}))

	# ensure cursor and input echoing back on upon a ctrl+c during read -s
	trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
	cursor_blink_off

	local active=0
	while true; do
		# print options by overwriting the last lines
		local idx=0
		for option in "${options[@]}"; do
			local prefix="[ ]"
			if [[ ${selected[idx]} == true ]]; then
				prefix="[x]"
			fi

			cursor_to $((startrow + idx))
			if [ $idx -eq $active ]; then
				print_active "$option" "$prefix"
			else
				print_inactive "$option" "$prefix"
			fi
			((idx++))
		done

		# user key control
		case $(key_input) in
		space) toggle_option selected $active ;;
		enter) break ;;
		up)
			((active--))
			if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi
			;;
		down)
			((active++))
			if [ $active -ge ${#options[@]} ]; then active=0; fi
			;;
		esac
	done

	# cursor position back to normal
	cursor_to "$lastrow"
	printf "\n"
	cursor_blink_on

	eval "$retval"='("${selected[@]}")'
}

# @description Check if repo is locked or not
# @noargs
git_crypt_check() {
	if [[ "$GIT_CRYPT_LOCKED" = "False" ]]; then
		message "Repo is currently unlocked with git-crypt. Installing decrypted file..."
		return 0
	else
		message "Repo is currently locked with git-crypt. Skipping encrypted file..."
		return 1
	fi
}

# @description Displays archinstaller logo
# @noargs
logo() {
	# This will be shown on every set as user is progressing
	echo -ne "
---------------------------------------------------------------------------------------------------------------------------------------
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
                                                                                                                                       
---------------------------------------------------------------------------------------------------------------------------------------
                                    Automated Dotfiles Installer
                        --------------------------------------------------
"
}

# @description Create a symbolic link from the given file/folder to a provided destination
# @arg $1 Source file/folder
# @arg $2 Destination file/folder
link_locations() {
	if [[ -L "$2" && -e "$2" ]]; then
		warning_message "Valid symlink already exists at $2. Skipping..."
		warning_message "If you would like to recreate, delete existing link and rerun."
	else
		if [ -f "$2" ] || [ -d "$2" ]; then
			message "$2 already exists. Removing..."
			rm -rf "$2"
		fi

		message "Creating a link from $1 at $2..."
		ln -s "$1" "$2"
		success_message "Successfully linked $2 to $1"
	fi
}

message() {
	printf "[>>] %s\n" "$*" >&2
}

# @description Remove existing files and copy from the given file/folder to a provided destination
# @arg $1 Source file/folder
# @arg $2 Destination file/folder
replace_files() {
	if [[ -L "$2" && -e "$2" ]]; then
		warning_message "Valid symlink already exists at $2. Skipping..."
		warning_message "If you would like to recreate, delete existing link and rerun."
	else
		if [ -f "$2" ] || [ -d "$2" ]; then
			message "$2 already exists. Removing..."
			rm -r "$2"
		fi

		message "Copying from $1 to $2..."
		cp -r "$1" "$2"
		success_message "Successfully replaced $2 with $1"
	fi
}

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
select_option() {

	# little helpers for terminal print control and key input
	ESC=$(printf "\033")
	cursor_blink_on() { printf "%s[?25h" "$ESC"; }
	cursor_blink_off() { printf "%s[?25l" "$ESC"; }
	cursor_to() { printf "%s[$1;${2:-1}H" "$ESC"; }
	print_option() { printf "%s   %s " "$2" "$1"; }
	print_selected() { printf "$2  %s[7m $1 %s[27m" "$ESC" "$ESC"; }
	get_cursor_row() {
		IFS=';' read -rsdR -p $'\E[6n' ROW COL
		echo "${ROW#*[}"
	}
	get_cursor_col() {
		IFS=';' read -rsdR -p $'\E[6n' ROW COL
		echo "${COL#*[}"
	}
	key_input() {
		local key
		IFS= read -rsn1 key 2>/dev/null >&2
		[[ $key = "" ]] && echo enter
		[[ $key = $'\x20' ]] && echo space
		[[ $key = "k" ]] && echo up
		[[ $key = "j" ]] && echo down
		[[ $key = "h" ]] && echo left
		[[ $key = "l" ]] && echo right
		[[ $key = "a" ]] && echo all
		[[ $key = "n" ]] && echo none
		if [[ $key = $'\x1b' ]]; then
			read -rsn2 key
			[[ $key = [A || $key = k ]] && echo up
			[[ $key = [B || $key = j ]] && echo down
			[[ $key = [C || $key = l ]] && echo right
			[[ $key = [D || $key = h ]] && echo left
		fi
	}
	print_options_multicol() {
		# print options by overwriting the last lines
		local curr_col=$1
		local curr_row=$2
		local curr_idx=0

		local idx=0
		local row=0
		local col=0

		curr_idx=$((curr_col + curr_row * colmax))

		for option in "${options[@]}"; do

			row=$((idx / colmax))
			col=$((idx - row * colmax))

			cursor_to $((startrow + row + 1)) $((offset * col + 1))
			if [ "$idx" -eq "$curr_idx" ]; then
				print_selected "$option"
			else
				print_option "$option"
			fi
			((idx++))
		done
	}

	# initially print empty new lines (scroll down if at bottom of screen)
	for opt; do printf "\n"; done

	# determine current screen position for overwriting the options
	local return_value=$1
	local lastrow=$(get_cursor_row)
	local lastcol=$(get_cursor_col)
	local startrow=$((lastrow - $#))
	local startcol=1
	local lines=$(tput lines)
	local cols=$(tput cols)
	local colmax=$2
	local offset=$((cols / colmax))

	local size=$4
	shift 4

	# ensure cursor and input echoing back on upon a ctrl+c during read -s
	trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
	cursor_blink_off

	local active_row=0
	local active_col=0
	while true; do
		print_options_multicol $active_col $active_row
		# user key control
		case $(key_input) in
		enter) break ;;
		up)
			((active_row--))
			[ $active_row -lt 0 ] && active_row=0
			;;
		down)
			((active_row++))
			[ $active_row -ge $((${#options[@]} / colmax)) ] && active_row=$((${#options[@]} / colmax))
			;;
		left)
			((active_col--))
			[ $active_col -lt 0 ] && active_col=0
			;;
		right)
			((active_col++))
			[ $active_col -ge "$colmax" ] && active_col=$((colmax - 1))
			;;
		esac
	done

	# cursor position back to normal
	cursor_to "$lastrow"
	printf "\n"
	cursor_blink_on

	return $((active_col + active_row * colmax))
}

# @description set options in setup.conf
# @arg $1 string Configuration variable.
# @arg $2 string Configuration value.
set_option() {
	grep -Eq "^${1}.*" "$CONFIG_FILE" && sed -i "/^${1}.*/d" "$CONFIG_FILE" # delete option if exists
	echo "${1}=${2}" >>"$CONFIG_FILE"                                       # add option
}

# @description Sources file to be used by the script
# @arg $1 File to source
source_file() {
	if [[ -f "$1" ]]; then
		source "$1"
	else
		error_message "ERROR! Missing file: $1"
		exit 0
	fi
}

setup_environment() {
	set -a # mark variables to be exported to subsequent commands

	CURRENT_TIME=$(date "+%Y.%m.%d-%H.%M.%S")
	BACKUP_LOCATION="$HOME/.dotfiles-backup/$CURRENT_TIME"

	GIT_DIR="$(git rev-parse --show-toplevel)"
	SCRIPTS_DIR="$GIT_DIR"/scripts
	DOTS_DIR="$GIT_DIR"/dots
	CONFIG_FILE="$GIT_DIR"/setup.conf
	LOG_FILE="$GIT_DIR"/install.log

	GIT_CRYPT_LOCKED=$(test -z "$(git config --local --get filter.git-crypt.smudge 2>/dev/null)" && echo "True" || echo "False")

	set +a

	declare -a files_to_source
	while IFS= read -r -d '' filename; do
		files_to_source+=("$filename")
	done < <(find "$SCRIPTS_DIR" -type f -name '*.sh' ! -name "$(basename "installer-helper.sh")" -print0 | sort -z)

	for filename in "${files_to_source[@]}"; do
		source "$filename"
	done

}

success_message() {
	if [ $? -eq 0 ]; then
		cecho "GREEN" "[>>] $1"
	fi
}

warning_message() {
	cecho "YELLOW" "[!!] $1"
}

setup_environment
