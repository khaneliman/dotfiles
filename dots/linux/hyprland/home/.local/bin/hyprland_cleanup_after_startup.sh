#!/usr/bin/env sh

sleep 10

hyprctl keyword windowrule "workspace unset,kitty"
hyprctl keyword windowrule "workspace unset,Code"
hyprctl keyword windowrule "workspace unset,title:^(GitKraken)$"
hyprctl keyword windowrule "workspace unset,GitHub Desktop"
hyprctl keyword windowrule "workspace unset,Slack"
hyprctl keyword windowrule "workspace unset,title:^(Heroic Games Launcher)$"
hyprctl keyword windowrule "workspace unset,firefox"
hyprctl keyword windowrule "workspace unset,discord"
hyprctl keyword windowrule "workspace unset,Steam"

exec hyprland_setup_dual_monitors.sh
