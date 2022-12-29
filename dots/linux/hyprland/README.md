#### Hyprland

[Catppuccin](https://github.com/catppuccin/catppuccin) themed [Hyprland](https://github.com/hyprwm/Hyprland) configuration with a lot more time spent on it since it's my current daily driver. There's basic dotfiles and then some [aconfmgr](https://github.com/CyberShadow/aconfmgr) config thrown in for deploying a system. (WIP and not tested thoroughly)

##### Unique Install Steps

- Create system links from ~/.local files to their /usr/local paths
- Create system link from ~/.config/waybar to /usr/local/share/waybar if you want automatic reload to work
    ```
    sudo ln -s ~/.local/share/wlroots-env/ /usr/local/share/
	sudo ln -s ~/.config/waybar/ /usr/local/share/waybar
	sudo ln -s ~/.local/bin/Hyprland-custom /usr/local/bin/
	sudo ln -s ~/.local/bin/xdg-desktop-portal.sh /usr/local/bin/
    sudo ln -s ~/.local/bin/hyprland_setup_dual_monitors.sh /usr/local/bin
	sudo ln -s ~/.local/bin/hyprland_cleanup_after_startup.s /usr/local/binh
	sudo ln -s ~/.local/bin/hyprland_handle_monitor_connect.sh /usr/local/bin	
    ```
- Enable user systemd services so the applications auto start properly (or add exec-once statements to ~/.config/hypr/hyprland.conf if you dont use systemd)
    ```
    systemctl --user enable --now hypr-waybar.service
	systemctl --user enable --now waybar-config.path
	systemctl --user enable --now hypr-swayidle.service
	systemctl --user enable --now hyprpaper.service
	systemctl --user enable --now hyprland-desktop-portal.service
    ```        
- Copy the dots/linux/hyprland/usr/share/wayland-sessions/hyprland-custom.desktop to /usr/share/wayland-sessions/

<div>
    <img src="https://github.com/khaneliman/dotfiles/blob/main/assets/linux-hyprland-tiling.png">
    <img src="https://github.com/khaneliman/dotfiles/blob/main/assets/linux-hyprland-wlogout.png">
</div>

