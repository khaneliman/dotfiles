{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.desktop.hyprland;
  term = config.khanelinix.desktop.addons.term;
  hyprBasePath = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.config/hypr/";
in
{
  options.khanelinix.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
    wallpaper = mkOpt (nullOr package) null "The wallpaper to display.";
    customConfigFiles = mkOpt attrs { } "Custom configuration files that can be used to override the default files.";
  };

  config = mkIf cfg.enable {
    # khanelinix.suites.desktop.windowManager = true;

    khanelinix.apps = {
      partitionmanager = enabled;
    };

    # Desktop additions
    khanelinix.desktop.addons = {
      gtk = enabled;
      qt = enabled;
      kitty = enabled;
      rofi = enabled;
      swappy = enabled;
      kanshi = enabled;
      keyring = enabled;
      nautilus = enabled;
      electron-support = enabled;
      swaylock = enabled;
      swayidle = enabled;
      swaynotificationcenter = enabled;
      thunar = enabled;
      waybar = enabled;
      wlogout = enabled;
      wdisplays = enabled;
      xdg-portal = enabled;
    };

    khanelinix.home.configFile =
      {
        "hypr/assets/square.png".source = hyprBasePath + "assets/square.png";
        "hypr/assets/diamond.png".source = hyprBasePath + "assets/diamond.png";
        "hypr/apps.conf".source = hyprBasePath + "apps.conf";
        "hypr/binds.conf".source = hyprBasePath + "binds.conf";
        "hypr/displays.conf".source = hyprBasePath + "displays.conf";
        "hypr/environment.conf".source = hyprBasePath + "environment.conf";
        "hypr/hyprland.conf".source = hyprBasePath + "hyprland.conf";
        "hypr/hyprpaper.conf".source = hyprBasePath + "hyprpaper.conf";
        "hypr/polish.conf".source = ./hypr/polish.conf;
        "hypr/variables.conf".source = hyprBasePath + "variables.conf";
        "hypr/windowrules.conf".source = hyprBasePath + "windowrules.conf";
        "mimeapps.list".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.config/mimeapps.list";
      }
      // cfg.customConfigFiles;

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
      khanelinix.catppuccin-sddm
      xwayland
      grim
      slurp
      swappy
      cliphist
      wl-clipboard
      wf-recorder
      libinput
      playerctl
      brightnessctl
      glib # for gsettings
      gtk3.out # for gtk-launch
      xdg-desktop-portal-hyprland
      hyprpaper
      hyprpicker
      swayimg
      blueman
      networkmanagerapplet
    ];

    services.xserver = {
      enable = true;

      libinput.enable = true;
      displayManager.sddm = {
        enable = true;
        theme = "catppuccin";
      };
    };

    # services.xserver.displayManager.defaultSession = "hyprland";
  };
}
