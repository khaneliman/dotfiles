#!/usr/bin/env bash
#github-action genshdoc
#
# @file User Options
# @brief User configuration functions to set variables to be used during installation
# @stdout Output routed to install.log
# @stderror Output routed to install.log

# @description Choose AUR helper.
# @noargs
aur_helper() {
	# Let the user choose AUR helper from predefined list
	echo -ne "Please select your desired AUR helper:\n"

	options=(paru yay picaur aura trizen pacaur NONE)

	select_option $? 4 "${options[@]}"

	aur_helper="${options[$?]}"

	set_option AUR_HELPER "$aur_helper"
}

# @description Choose Desktop Environment
# @noargs
desktop_environment() {
	# Let the user choose Desktop Enviroment from predefined list
	echo -ne "Please select your desired Desktop Enviroment:\n"

	mapfile -t options < <(for f in scripts/desktop-environment/*.sh; do echo "${f##*/}" | sed -r 's/\.[^.]*$//'; done)

	select_option $? 4 "${options[@]}"

	desktop_env="${options[$?]}"

	set_option DESKTOP_ENV "$desktop_env"
}
