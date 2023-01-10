#!/usr/bin/env bash

#github-action genshdoc
#
# @file Hyprland custom script
# @brief Contains the functions used to configure and theme Hyprland window manager
# @stdout Output routed to install.log
# @stderror Output routed to install.log

hypr_backup_existing() {
	echo "Backing up existing dotfiles to $BACKUP_LOCATION"

	mkdir -p "$BACKUP_LOCATION"

	# backup .config
	mv ~/.config/Kvantum "$BACKUP_LOCATION"
	mv ~/.config/aconfmgr "$BACKUP_LOCATION"
	mv ~/.config/gtk-2.0 "$BACKUP_LOCATION"
	mv ~/.config/gtk-3.0 "$BACKUP_LOCATION"
	mv ~/.config/gtk-4.0 "$BACKUP_LOCATION"
	mv ~/.config/hypr "$BACKUP_LOCATION"
	mv ~/.config/mako "$BACKUP_LOCATION"
	mv ~/.config/paru "$BACKUP_LOCATION"
	mv ~/.config/qt5ct "$BACKUP_LOCATION"
	mv ~/.config/qt6ct "$BACKUP_LOCATION"
	mv ~/.config/rofi "$BACKUP_LOCATION"
	mv ~/.config/swappy "$BACKUP_LOCATION"
	mv ~/.config/swaylock "$BACKUP_LOCATION"
	mv ~/.config/systemd "$BACKUP_LOCATION"
	mv ~/.config/waybar "$BACKUP_LOCATION"
	mv ~/.config/wlogout "$BACKUP_LOCATION"

	mv ~/.screenlayout/primary.sh "$BACKUP_LOCATION"
	mv ~/.gtkrc-2.0 "$BACKUP_LOCATION"
}

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
	hypr_backup_existing

	hypr_copy_configuration
	hypr_create_symlink
	hypr_enable_systemd_services

	cat_theme_all
}
