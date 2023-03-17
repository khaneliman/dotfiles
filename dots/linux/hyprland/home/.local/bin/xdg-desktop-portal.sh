#!/usr/bin/env sh

sleep 1

killall xdg-desktop-portal-hyprland
killall xdg-desktop-portal-gtk
killall xdg-desktop-portal

/usr/lib/xdg-desktop-portal-hyprland &

sleep 2

/usr/lib/xdg-desktop-portal-gtk &

sleep 2

/usr/lib/xdg-desktop-portal &
