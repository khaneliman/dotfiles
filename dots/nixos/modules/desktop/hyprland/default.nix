{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.desktop.hyprland;
  term = config.khanelinix.desktop.addons.term;
in {
  options.khanelinix.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
    wallpaper = mkOpt (nullOr package) null "The wallpaper to display.";
    extraConfig =
      mkOpt str "" "Additional configuration for the hyprland config file.";
  };

  config = mkIf cfg.enable {
    # Desktop additions
    khanelinix.desktop.addons = {
      gtk = enabled;
      kitty = enabled;
      rofi = enabled;
      swappy = enabled;
      kanshi = enabled;
      keyring = enabled;
      nautilus = enabled;
      electron-support = enabled;
    };

    khanelinix.home.configFile."hypr/".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.config/hypr";
    khanelinix.home.file = {
      ".local/bin/xdg-desktop-portal.sh".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.local/bin/xdg-desktop-portal.sh";
      ".local/bin/hyprland_setup_dual_monitors.sh".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.local/bin/hyprland_setup_dual_monitors.sh";
      ".local/bin/hyprland_cleanup_after_startup.sh".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.local/bin/hyprland_cleanup_after_startup.sh";
      ".local/bin/hyprland_handle_monitor_connect.sh".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.local/bin/hyprland_handle_monitor_connect.sh";
      ".local/bin/record_screen".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.local/bin/record_screen";
      ".local/bin/grimblast".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.local/bin/grimblast";
    };

    programs.hyprland = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      rofi
      swaylock-effects
      swayidle
      xwayland
      grim
      cliphist
      wl-clipboard
      wf-recorder
      libinput
      playerctl
      brightnessctl
      glib # for gsettings
      gtk3.out # for gtk-launch
      gnome.gnome-control-center
      swaynotificationcenter
      waybar
      xdg-desktop-portal-wlr
      xdg-desktop-portal-hyprland
      wlogout
      hyprpaper
      hyprpicker
      swayimg
      blueman
      networkmanagerapplet
      polkit-kde-agent
      gnome.gnome-keyring
    ];

    services.xserver.enable = true;
    services.xserver.displayManager.defaultSession = "hyprland";
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;
    services.xserver.libinput.enable = true;
  };
}
