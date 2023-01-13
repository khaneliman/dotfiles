#!/usr/bin/env bash

linux_install() {

	desktop_environment

	source_file "$CONFIG_FILE"

	case "$DESKTOP_ENV" in
	hyprland)
		hyprland_install
		;;
	awesome)
		awesome_install
		;;
	gnome)
		gnome_install
		;;
	*)
		message '[!!] No desktop environment selected... aborting...'
		exit
		;;
	esac
}
