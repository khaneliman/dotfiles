# Boot customization files
CopyFile /boot/os_arch.png 700
CopyFile /boot/refind_linux.conf
CopyFile /boot/vmlinuz-linux.png 700
CopyFile /boot/vmlinuz-linux-zen.png 700

# Snapper config
CopyFile /etc/conf.d/snapper
CopyFile /etc/snapper/configs/home 640
CopyFile /etc/snapper/configs/root

# Misc customizations
CopyFile /etc/davmail.properties
CopyFile /etc/btrfs-assistant.conf
CopyFile /etc/default/btrfsmaintenance
CopyFile /etc/plymouth/plymouthd.conf
CopyFile /etc/sddm.conf
CopyFile /etc/profile
CopyFile /etc/systemd/system/btrfs-balance.timer.d/schedule.conf
CopyFile /etc/systemd/system/btrfs-scrub.timer.d/schedule.conf
CopyFile /etc/systemd/system/davmail.service
CopyFile /etc/sysctl.d/99-sysrq.conf

# Virtual Machines
CopyFile /etc/libvirt/qemu/archlinux.xml 600
CopyFile /etc/libvirt/qemu/macOS.xml 600
CopyFile /etc/libvirt/qemu/networks/default.xml
CopyFile /etc/libvirt/qemu/nobara-btrfs.xml 600
CopyFile /etc/libvirt/qemu/Nobara.xml 600
CopyFile /etc/libvirt/qemu/Windows-11\(2\).xml 600
CreateLink /etc/libvirt/storage/autostart/default.xml /etc/libvirt/storage/default.xml
CreateLink /etc/libvirt/storage/autostart/ISOs.xml /etc/libvirt/storage/ISOs.xml
CreateLink /etc/libvirt/storage/autostart/kvm.xml /etc/libvirt/storage/kvm.xml
CreateLink /etc/libvirt/storage/autostart/macOS-Monterey.xml /etc/libvirt/storage/macOS-Monterey.xml
CopyFile /etc/libvirt/storage/default.xml 600
CopyFile /etc/libvirt/storage/ISOs.xml 600
CopyFile /etc/libvirt/storage/kvm.xml 600
CopyFile /etc/libvirt/storage/macOS-Monterey.xml 600

# Locale
CopyFile /etc/locale.conf
CopyFile /etc/locale.gen
CreateLink /etc/localtime /usr/share/zoneinfo/America/Chicago

# Modules loading
CopyFile /etc/mkinitcpio.conf
CopyFile /etc/modules-load.d/10-i2c.conf

# Polkit rules
CopyFile /etc/polkit-1/localauthority/50-local.d/10-udisks.pkla
CopyFile /etc/polkit-1/rules.d/50-udiskie.rules
CopyFile /etc/polkit-1/rules.d/allow-mount-internal.rules

# Network tweaks
CopyFile /etc/NetworkManager/system-connections/sweden.nmconnection 600
CopyFile /etc/NetworkManager/system-connections/us_chicago.nmconnection 600
CopyFile /etc/nsswitch.conf
CopyFile /etc/ntpd.service.d/ntpd-ipv4.conf
CopyFile /etc/pacman.conf
CopyFile /etc/pacman.d/mirrorlist
CopyFile /etc/paru.conf

# Udev rules
CopyFile /usr/lib/udev/rules.d/60-openrgb.rules.bak
CopyFile /usr/lib/udev/rules.d/71-8bitdo-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-alpha_imaging_technology_co-vr.rules
CopyFile /usr/lib/udev/rules.d/71-astro_gaming-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-betop-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-hori-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-htc-vr.rules
CopyFile /usr/lib/udev/rules.d/71-logitech-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-mad_catz-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-microsoft-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-nacon-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-nintendo-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-nvidia-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-pdp-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-personal_communication_systems_inc-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-powera-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-razer-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-sony-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-sony-vr.rules
CopyFile /usr/lib/udev/rules.d/71-valve-controllers.rules
CopyFile /usr/lib/udev/rules.d/71-valve-vr.rules
CopyFile /usr/lib/udev/rules.d/71-zeroplus_technology_corporation-controllers.rules
CopyFile /usr/lib/udev/rules.d/99-i2c.rules

CopyFile /etc/sudoers
CopyFile /etc/shells
CopyFile /etc/ssh/ssh_host_ecdsa_key 600
CopyFile /etc/ssh/ssh_host_ecdsa_key.pub
CopyFile /etc/ssh/ssh_host_ed25519_key 600
CopyFile /etc/ssh/ssh_host_ed25519_key.pub
CopyFile /etc/ssh/ssh_host_rsa_key 600
CopyFile /etc/ssh/ssh_host_rsa_key.pub
CopyFile /etc/systemd/journald.conf

# Enabled services
CreateLink /etc/systemd/system/dbus-org.bluez.service /usr/lib/systemd/system/bluetooth.service
CreateLink /etc/systemd/system/dbus-org.freedesktop.Avahi.service /usr/lib/systemd/system/avahi-daemon.service
CreateLink /etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service /usr/lib/systemd/system/NetworkManager-dispatcher.service
CreateLink /etc/systemd/system/display-manager.service /usr/lib/systemd/system/sddm.service
CreateLink /etc/systemd/user/default.target.wants/xdg-user-dirs-update.service /usr/lib/systemd/user/xdg-user-dirs-update.service
CreateLink /etc/systemd/user/pipewire.service.wants/wireplumber.service /usr/lib/systemd/user/wireplumber.service
CreateLink /etc/systemd/user/pipewire-session-manager.service /usr/lib/systemd/user/wireplumber.service
CreateLink /etc/systemd/user/sockets.target.wants/gcr-ssh-agent.socket /usr/lib/systemd/user/gcr-ssh-agent.socket
CreateLink /etc/systemd/user/sockets.target.wants/gnome-keyring-daemon.socket /usr/lib/systemd/user/gnome-keyring-daemon.socket
CreateLink /etc/systemd/user/sockets.target.wants/p11-kit-server.socket /usr/lib/systemd/user/p11-kit-server.socket
CreateLink /etc/systemd/user/sockets.target.wants/pipewire-pulse.socket /usr/lib/systemd/user/pipewire-pulse.socket
CreateLink /etc/systemd/user/sockets.target.wants/pipewire.socket /usr/lib/systemd/user/pipewire.socket

# Pacman hooks
CopyFile /usr/share/libalpm/hooks/arch-audit.hook
CopyFile /usr/share/libalpm/hooks/zzx-orphans.hook
CopyFile /usr/share/libalpm/hooks/zzz-archcraft-reboot-required.hook
CopyFile /usr/share/libalpm/hooks/zzz-needrestart-pacman.hook

CreateLink ~/.local/bin/Hyprland-custom /usr/local/bin/Hyprland-custom 755
CreateLink ~/.local/bin/xdg-desktop-portal.sh /usr/local/bin/xdg-desktop-portal.sh
CreateLink ~/.local/share/wlroots-env/ /usr/share/
CopyFile /usr/share/wayland-sessions/hyprland-custom.desktop

CopyFile /etc/vconsole.conf
CopyFile /etc/X11/xorg.conf
CopyFile /usr/bin/archcraft-reboot-required 755

# System Fonts
CopyFile /usr/share/fonts/CascadiaCode/Caskaydia\ Cove\ Nerd\ Font\ Complete\ Mono.ttf
CopyFile /usr/share/fonts/CascadiaCode/Caskaydia\ Cove\ Nerd\ Font\ Complete\ Mono\ Windows\ Compatible.ttf
CopyFile /usr/share/fonts/CascadiaCode/Caskaydia\ Cove\ Nerd\ Font\ Complete.ttf
CopyFile /usr/share/fonts/CascadiaCode/Caskaydia\ Cove\ Nerd\ Font\ Complete\ Windows\ Compatible.ttf
CopyFile /usr/share/fonts/Roboto_Condensed/LICENSE.txt
CopyFile /usr/share/fonts/Roboto_Condensed/RobotoCondensed-BoldItalic.ttf
CopyFile /usr/share/fonts/Roboto_Condensed/RobotoCondensed-Bold.ttf
CopyFile /usr/share/fonts/Roboto_Condensed/RobotoCondensed-Italic.ttf
CopyFile /usr/share/fonts/Roboto_Condensed/RobotoCondensed-LightItalic.ttf
CopyFile /usr/share/fonts/Roboto_Condensed/RobotoCondensed-Light.ttf
CopyFile /usr/share/fonts/Roboto_Condensed/RobotoCondensed-Regular.ttf
CopyFile /usr/share/fonts/sf-pro-display-cufonfonts/SFPRODISPLAYBLACKITALIC.OTF
CopyFile /usr/share/fonts/sf-pro-display-cufonfonts/SFPRODISPLAYBOLD.OTF
CopyFile /usr/share/fonts/sf-pro-display-cufonfonts/SFPRODISPLAYHEAVYITALIC.OTF
CopyFile /usr/share/fonts/sf-pro-display-cufonfonts/SFPRODISPLAYLIGHTITALIC.OTF
CopyFile /usr/share/fonts/sf-pro-display-cufonfonts/SFPRODISPLAYMEDIUM.OTF
CopyFile /usr/share/fonts/sf-pro-display-cufonfonts/SFPRODISPLAYREGULAR.OTF
CopyFile /usr/share/fonts/sf-pro-display-cufonfonts/SFPRODISPLAYSEMIBOLDITALIC.OTF
CopyFile /usr/share/fonts/sf-pro-display-cufonfonts/SFPRODISPLAYTHINITALIC.OTF
CopyFile /usr/share/fonts/sf-pro-display-cufonfonts/SFPRODISPLAYULTRALIGHTITALIC.OTF
CopyFile /usr/share/fonts/typicons.ttf

# Plymouth theme
CopyFile /usr/share/plymouth/plymouthd.defaults
CopyFile /usr/share/plymouth/themes/arch-glow/arch-glow.plymouth
CopyFile /usr/share/plymouth/themes/arch-glow/box.png
CopyFile /usr/share/plymouth/themes/arch-glow/bullet.png
CopyFile /usr/share/plymouth/themes/arch-glow/entry.png
CopyFile /usr/share/plymouth/themes/arch-glow/lock.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-00.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-01.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-02.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-03.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-04.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-05.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-06.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-07.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-08.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-09.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-10.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-11.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-12.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-13.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-14.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-15.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-16.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-17.png
CopyFile /usr/share/plymouth/themes/arch-glow/progress-18.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-00.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-01.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-02.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-03.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-04.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-05.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-06.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-07.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-08.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-09.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-10.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-11.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-12.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-13.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-14.png
CopyFile /usr/share/plymouth/themes/arch-glow/throbber-15.png
CopyFile /usr/share/plymouth/themes/arch-glow/Thumbs.db

# SDDM Theme
CopyFile /usr/share/sddm/faces/khaneliman.face.icon
CopyFile /usr/share/sddm/themes/catppuccin-macchiato/angle-down.png
CopyFile /usr/share/sddm/themes/catppuccin-macchiato/background.jpg
CopyFile /usr/share/sddm/themes/catppuccin-macchiato/backup.png
CopyFile /usr/share/sddm/themes/catppuccin-macchiato/Main.qml
CopyFile /usr/share/sddm/themes/catppuccin-macchiato/metadata.desktop
CopyFile /usr/share/sddm/themes/catppuccin-macchiato/rectangle.png
CopyFile /usr/share/sddm/themes/catppuccin-macchiato/theme.conf
CopyFile /usr/share/sddm/themes/catppuccin-macchiato/ultimate.png

# System theme
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/add-workspace-active.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/add-workspace-hover.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/add-workspace.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/calendar-arrow-left.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/calendar-arrow-right.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/checkbox-dark.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/checkbox-off.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/checkbox.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/close-active.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/close-hover.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/close.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/corner-ripple.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/radiobutton-dark.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/radiobutton-off.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/radiobutton.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/toggle-off.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/toggle-on-dark.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/toggle-on.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/assets/trash-icon.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/cinnamon.css
CopyFile /usr/share/themes/Catppuccin-Macchiato/cinnamon/thumbnail.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/calendar-arrow-left.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/calendar-arrow-right.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/calendar-today.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/checkbox-dark.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/checkbox-off-active.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/checkbox-off-hover.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/checkbox-off.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/checkbox.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/dash-placeholder.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/no-events.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/noise-texture.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/no-notifications.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/process-working.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/toggle-off-dark.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/toggle-off.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/toggle-on-dark.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/assets/toggle-on.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/gnome-shell.css
CreateLink /usr/share/themes/Catppuccin-Macchiato/gnome-shell/no-events.svg assets/no-events.svg
CreateLink /usr/share/themes/Catppuccin-Macchiato/gnome-shell/no-notifications.svg assets/no-notifications.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gnome-shell/pad-osd.css
CreateLink /usr/share/themes/Catppuccin-Macchiato/gnome-shell/process-working.svg assets/process-working.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/apps.rc
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/border.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/button-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/button-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/button-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/button.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-checked-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-checked-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-checked-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-checked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-mixed-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-mixed-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-mixed-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-mixed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-unchecked-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-unchecked-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-unchecked-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/checkbox-unchecked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/combo-left-entry-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/combo-left-entry-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/combo-left-entry-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/combo-left-entry.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/combo-right-entry-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/combo-right-entry-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/combo-right-entry-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/combo-right-entry.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/entry-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/entry-background-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/entry-background.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/entry-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/entry-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/entry.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/flat-button-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/flat-button-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/flat-button-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/flat-button.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/focus.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/frame-inline.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/frame-notebook.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/frame.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/handle-horz-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/handle-horz-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/handle-horz.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/handle-vert-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/handle-vert-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/handle-vert.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-checkbox-checked-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-checkbox-checked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-checkbox-mixed-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-checkbox-mixed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-checkbox-unchecked-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-checkbox-unchecked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-radio-checked-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-radio-checked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-radio-mixed-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-radio-mixed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-radio-unchecked-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/menu-radio-unchecked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-down-alt-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-down-alt.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-down-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-down.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-left-alt-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-left-alt.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-left-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-left.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-left-semi.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-right-alt-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-right-alt.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-right-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-right.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-right-semi.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-up-alt-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-up-alt.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-up-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/pan-up.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/progressbar-progress.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/progressbar-trough.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-checked-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-checked-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-checked-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-checked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-mixed-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-mixed-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-mixed-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-mixed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-unchecked-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-unchecked-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-unchecked-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/radio-unchecked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scale-horz-trough-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scale-horz-trough-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scale-horz-trough.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scale-slider-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scale-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scale-slider-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scale-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scale-vert-trough-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scale-vert-trough-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scale-vert-trough.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-horz-slider-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-horz-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-horz-slider-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-horz-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-horz-trough.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-vert-ltr-slider-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-vert-ltr-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-vert-ltr-slider-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-vert-ltr-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-vert-ltr-trough.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-vert-rtl-slider-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-vert-rtl-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-vert-rtl-slider-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-vert-rtl-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/scrollbar-vert-rtl-trough.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-ltr-down-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-ltr-down-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-ltr-down-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-ltr-down.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-ltr-up-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-ltr-up-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-ltr-up-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-ltr-up.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-rtl-down-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-rtl-down-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-rtl-down-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-rtl-down.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-rtl-up-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-rtl-up-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-rtl-up-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/spin-rtl-up.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/tab.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/treeview-ltr-button-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/treeview-ltr-button-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/treeview-ltr-button.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/treeview-rtl-button-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/treeview-rtl-button-hover.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/assets/treeview-rtl-button.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/gtkrc
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/hacks.rc
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-2.0/main.rc
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/checkbox-checked-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/checkbox-checked-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/checkbox-mixed-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/checkbox-mixed-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/close.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/cursor-handle-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/maximize.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/minimize.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/radio-checked-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/radio-checked-symbolic.svg
CreateLink /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/radio-mixed-symbolic@2.svg checkbox-mixed-symbolic@2.svg
CreateLink /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/radio-mixed-symbolic.svg checkbox-mixed-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/scale-horz-marks-after-slider-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/scale-horz-marks-before-slider-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/scale-slider-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/scale-vert-marks-after-slider-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/scale-vert-marks-before-slider-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/small-checkbox-checked-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/small-checkbox-checked-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/small-checkbox-mixed-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/small-checkbox-mixed-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/small-radio-checked-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/small-radio-checked-symbolic.svg
CreateLink /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/small-radio-mixed-symbolic@2.svg small-checkbox-mixed-symbolic@2.svg
CreateLink /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/small-radio-mixed-symbolic.svg small-checkbox-mixed-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scalable/unmaximize.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-after-slider@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-after-slider-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-after-slider-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-after-slider-disabled@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-after-slider-disabled-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-after-slider-disabled-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-after-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-after-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-before-slider@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-before-slider-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-before-slider-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-before-slider-disabled@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-before-slider-disabled-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-before-slider-disabled-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-before-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-horz-marks-before-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-after-slider@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-after-slider-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-after-slider-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-after-slider-disabled@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-after-slider-disabled-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-after-slider-disabled-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-after-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-after-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-before-slider@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-before-slider-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-before-slider-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-before-slider-disabled@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-before-slider-disabled-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-before-slider-disabled-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-before-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/scale-vert-marks-before-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/selectionmode-checkbox-checked@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/selectionmode-checkbox-checked-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/selectionmode-checkbox-checked-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/selectionmode-checkbox-checked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/selectionmode-checkbox-unchecked@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/selectionmode-checkbox-unchecked-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/selectionmode-checkbox-unchecked-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/assets/selectionmode-checkbox-unchecked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/gtk.css
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/gtk-dark.css
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-3.0/thumbnail.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/checkbox-checked-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/checkbox-checked-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/checkbox-mixed-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/checkbox-mixed-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/close.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/cursor-handle-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/maximize.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/minimize.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/radio-checked-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/radio-checked-symbolic.svg
CreateLink /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/radio-mixed-symbolic@2.svg checkbox-mixed-symbolic@2.svg
CreateLink /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/radio-mixed-symbolic.svg checkbox-mixed-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/scale-horz-marks-after-slider-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/scale-horz-marks-before-slider-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/scale-slider-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/scale-vert-marks-after-slider-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/scale-vert-marks-before-slider-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/small-checkbox-checked-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/small-checkbox-checked-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/small-checkbox-mixed-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/small-checkbox-mixed-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/small-radio-checked-symbolic@2.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/small-radio-checked-symbolic.svg
CreateLink /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/small-radio-mixed-symbolic@2.svg small-checkbox-mixed-symbolic@2.svg
CreateLink /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/small-radio-mixed-symbolic.svg small-checkbox-mixed-symbolic.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scalable/unmaximize.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-after-slider@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-after-slider-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-after-slider-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-after-slider-disabled@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-after-slider-disabled-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-after-slider-disabled-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-after-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-after-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-before-slider@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-before-slider-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-before-slider-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-before-slider-disabled@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-before-slider-disabled-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-before-slider-disabled-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-before-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-horz-marks-before-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-after-slider@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-after-slider-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-after-slider-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-after-slider-disabled@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-after-slider-disabled-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-after-slider-disabled-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-after-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-after-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-before-slider@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-before-slider-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-before-slider-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-before-slider-disabled@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-before-slider-disabled-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-before-slider-disabled-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-before-slider-disabled.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/scale-vert-marks-before-slider.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/selectionmode-checkbox-checked@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/selectionmode-checkbox-checked-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/selectionmode-checkbox-checked-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/selectionmode-checkbox-checked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/selectionmode-checkbox-unchecked@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/selectionmode-checkbox-unchecked-dark@2.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/selectionmode-checkbox-unchecked-dark.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/assets/selectionmode-checkbox-unchecked.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/gtk.css
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/gtk-dark.css
CopyFile /usr/share/themes/Catppuccin-Macchiato/gtk-4.0/thumbnail.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/index.theme
CopyFile /usr/share/themes/Catppuccin-Macchiato/metacity-1/assets/button.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/metacity-1/assets/close.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/metacity-1/assets/maximize.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/metacity-1/assets/menu.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/metacity-1/assets/minimize.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/metacity-1/assets/shade.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/metacity-1/assets/unmaximize.svg
CopyFile /usr/share/themes/Catppuccin-Macchiato/metacity-1/assets/unshade.svg
CreateLink /usr/share/themes/Catppuccin-Macchiato/metacity-1/metacity-theme-1.xml metacity-theme-3.xml
CreateLink /usr/share/themes/Catppuccin-Macchiato/metacity-1/metacity-theme-2.xml metacity-theme-3.xml
CopyFile /usr/share/themes/Catppuccin-Macchiato/metacity-1/metacity-theme-3.xml
CopyFile /usr/share/themes/Catppuccin-Macchiato/metacity-1/thumbnail.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/plank/dock.theme
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/bottom-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/bottom-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/bottom-left-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/bottom-left-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/bottom-right-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/bottom-right-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/close-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/close-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/close-prelight.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/close-pressed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/hide-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/hide-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/hide-prelight.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/hide-pressed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/left-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/left-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/maximize-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/maximize-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/maximize-prelight.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/maximize-pressed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/maximize-toggled-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/maximize-toggled-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/maximize-toggled-prelight.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/maximize-toggled-pressed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/menu-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/menu-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/menu-prelight.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/menu-pressed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/right-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/right-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/shade-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/shade-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/shade-prelight.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/shade-pressed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/stick-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/stick-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/stick-prelight.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/stick-pressed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/stick-toggled-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/stick-toggled-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/stick-toggled-prelight.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/stick-toggled-pressed.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/themerc
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/title-1-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/title-1-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/title-2-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/title-2-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/title-3-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/title-3-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/title-4-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/title-4-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/title-5-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/title-5-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/top-left-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/top-left-inactive.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/top-right-active.png
CopyFile /usr/share/themes/Catppuccin-Macchiato/xfwm4/top-right-inactive.png

CopyFile /usr/share/wallpapers/butterfly.png

SetFileProperty /etc/bluetooth mode 755
