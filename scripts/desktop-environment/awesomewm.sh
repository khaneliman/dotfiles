#!/usr/bin/env bash

#github-action genshdoc
#
# @file AwesomeWM custom script
# @brief Contains the functions used to configure and theme AwesomeWM window manager
# @stdout Output routed to install.log
# @stderror Output routed to install.log

awesome_copy_configuration() {
	# copy home folder dotfiles
	cp -r "$DOTS_DIR"/linux/awesome/home/. ~

	sudo mkdir -p /etc/lightdm/
	sudo cp "$DOTS_DIR"/linux/awesome/etc/lightdm/slick-greeter.conf /etc/lightdm/
}

awesome_install() {
	awesome_copy_configuration

	glass_theme_all
}
