#!/usr/bin/env bash

#github-action genshdoc
#
# @file Hyprland custom script
# @brief Contains the functions used to configure and theme Hyprland window manager
# @stdout Output routed to install.log
# @stderror Output routed to install.log

hypr_create_symlink() {
	sudo ln -s ~/.local/share/wlroots-env/ /usr/local/share/
	sudo ln -s ~/.config/waybar/ /usr/local/share/waybar
	sudo ln -s ~/.local/bin/Hyprland-custom /usr/local/bin/
	sudo ln -s ~/.local/bin/xdg-desktop-portal.sh /usr/local/bin/
	sudo ln -s ~/.local/bin/hyprland_setup_dual_monitors.sh /usr/local/bin
	sudo ln -s ~/.local/bin/hyprland_cleanup_after_startup.s /usr/local/binh
	sudo ln -s ~/.local/bin/hyprland_handle_monitor_connect.sh /usr/local/bin
}

hypr_enable_systemd_services() {
	systemctl --user enable --now hypr-waybar.service
	systemctl --user enable --now waybar-config.path
	systemctl --user enable --now hypr-swayidle.service
	systemctl --user enable --now hyprpaper.service
	systemctl --user enable --now hyprland-desktop-portal.service
}

hypr_copy_configuration() {
	# copy home folder dotfiles
	cp -r "$DOTS_DIR"/linux/hyprland/home/. ~

	# copy desktop file for display manager
	sudo mkdir -p /usr/share/wayland-sessions/
	sudo cp "$DOTS_DIR"/linux/hyprland/usr/share/wayland-sessions/hyprland-custom.desktop /usr/share/wayland-sessions/
}

hyprland_install() {
	hypr_copy_configuration
	hypr_create_symlink
	hypr_enable_systemd_services
}

