#!/usr/bin/env bash
#
# ░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀░█░█░█▄█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
# ░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀░█▄█░█░█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
# ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
#

#github-action genshdoc
#
# @file AwesomeWM custom script
# @brief Contains the functions used to configure and theme AwesomeWM window manager
# @stdout Output routed to install.log
# @stderror Output routed to install.log

#
# ░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀░█░█░█▀▄░█▀█░▀█▀░▀█▀░█▀█░█▀█
# ░█░░░█░█░█░█░█▀▀░░█░░█░█░█░█░█▀▄░█▀█░░█░░░█░░█░█░█░█
# ░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀
#
awesome_copy_configuration() {
	message "Copying config files for awesomewm"

	# copy home folder dotfiles
	copy_files "$DOTS_DIR"/linux/awesome/home/. ~

	sudo mkdir -p /etc/lightdm/
	sudo cp "$DOTS_DIR"/linux/awesome/etc/lightdm/slick-greeter.conf /etc/lightdm/
	success_message "Themed lightdm"
}

awesome_install() {
	awesome_copy_configuration

	glass_theme_all
}
