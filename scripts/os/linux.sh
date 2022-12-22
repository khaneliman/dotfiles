#!/usr/bin/env bash

linux_install() {

	desktop_environment
 
 	source_file "$CONFIG_FILE"

	case "$DESKTOP_ENV" in 
		hyprland)
			hyprland_install
 			;;
 		awesome)
 			echo 'Awesome currently not set up, manually copy files...'
 			;;
 		gnome)
 			echo 'Gnome currently not set up, manually copy files...'
 			;;
 		esac
	}
