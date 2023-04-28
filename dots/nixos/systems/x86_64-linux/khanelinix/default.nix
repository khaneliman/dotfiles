{ pkgs
, lib
, config
, ...
}:
with lib;
with lib.internal; {
  imports = [ ./hardware.nix ];

  khanelinix = {
    nix = enabled;

    archetypes = {
      gaming = enabled;
      workstation = enabled;
    };

    apps = {
      _1password = enabled;
      firefox = enabled;
      vscode = enabled;
    };

    cli-apps = { };

    desktop = {
      hyprland = {
        enable = true;

        customConfigFiles = {
          "hypr/polish.conf".source = (pkgs.writeTextFile {
            name = "polish.conf";
            text = ''
              # ░█▀█░█▀█░█░░░▀█▀░█▀▀░█░█
              # ░█▀▀░█░█░█░░░░█░░▀▀█░█▀█
              # ░▀░░░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀

              # ░▀█▀░█░█░█▀▀░█▄█░█▀▀
              # ░░█░░█▀█░█▀▀░█░█░█▀▀
              # ░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀

              hyprctl setcursor Catppuccin-Mocha-Dark-Cursors 32

              # gsettings
              exec-once = gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Dark'
              #exec-once = gsettings set org.gnome.desktop.interface icon-theme 'oomox-Catppuccin-Macchiato'
              exec-once = gsettings set org.gnome.desktop.interface font-name 'Liga SFMono Nerd Font 10'
              exec-once = gsettings set org.gnome.desktop.interface cursor-theme 'Catppuccin-Mocha-Dark-Cursors'
              exec-once = gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
              exec-once = gsettings set org.gnome.desktop.interface enable-animations true

              # ░█░█░█▀█░█▀▄░█░█░█▀▀░█▀█░█▀█░█▀▀░█▀▀░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
              # ░█▄█░█░█░█▀▄░█▀▄░▀▀█░█▀▀░█▀█░█░░░█▀▀░░░█░░░█░█░█░█░█▀▀░░█░░█░█
              # ░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░░▀░▀░▀▀▀░▀▀▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀
              # Move workspaces to correct monitor
              exec-once = hyprland_handle_monitor_connect.sh


              # ░█▀▀░█▀▄░█▀▀░█▀▀░▀█▀░█▀▀░█▀▄
              # ░█░█░█▀▄░█▀▀░█▀▀░░█░░█▀▀░█▀▄
              # ░▀▀▀░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀

              # greeting
              exec = notify-send --icon ~/.face -u normal "Hello $(whoami)"
            '';
          });
          "hypr/environment.conf".source = (pkgs.writeTextFile {
            name = "environment.conf";
            text = ''
              ##
              # ░█▀▀░█▀█░█░█░▀█▀░█▀▄░█▀█░█▀█░█▄█░█▀▀░█▀█░▀█▀
              # ░█▀▀░█░█░▀▄▀░░█░░█▀▄░█░█░█░█░█░█░█▀▀░█░█░░█░
              # ░▀▀▀░▀░▀░░▀░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░░▀░
              ##


              # ░█░█░█░░░█▀▄░█▀█░█▀█░▀█▀░█▀▀
              # ░█▄█░█░░░█▀▄░█░█░█░█░░█░░▀▀█
              # ░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀

              env = WLR_RENDERER,vulkan
              env = XDG_SESSION_TYPE,wayland
              env = QT_QPA_PLATFORM,wayland
              env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
              env = MOZ_ENABLE_WAYLAND,1
              env = MOZ_USE_XINPUT2,1
              env = __GL_GSYNC_ALLOWED,0
              env = __GL_VRR_ALLOWED,0
              env = SDL_VIDEODRIVER,wayland
              env = _JAVA_AWT_WM_NONEREPARENTING,1


              # ░▀█▀░█░█░█▀▀░█▄█░█▀▀
              # ░░█░░█▀█░█▀▀░█░█░█▀▀
              # ░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀

              # Theme variables
              env = QT_QPA_PLATFORMTHEME,qt5ct
              env = GTK_THEME,Catppuccin-Dark
              env = XCURSOR_SIZE,32
              env = XCURSOR_THEME,Catppuccin-Mocha-Dark-Cursors


              # ░█░█░█░█░█▀█░█▀▄░█░░░█▀█░█▀█░█▀▄
              # ░█▀█░░█░░█▀▀░█▀▄░█░░░█▀█░█░█░█░█
              # ░▀░▀░░▀░░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀░

              env = XDG_SESSION_DESKTOP,Hyprland
              env = XDG_CURRENT_DESKTOP,Hyprland
              env = HYPRLAND_LOG_WLR,1
              env = ASAN_OPTIONS,log_path=~/asan.log
            '';
          });
        };
      };

      addons = {
        # I like to have a convenient place to share wallpapers from
        # even if they're not currently being used.
        wallpapers = enabled;
      };
    };

    suites = {
      desktop = mkForce disabled;
    };

    tools = {
      k8s = enabled;
      git = enabled;
      node = enabled;
      http = enabled;
      misc = enabled;
      oh-my-posh = enabled;
    };

    hardware = {
      amdgpu = enabled;
      audio = enabled;
      networking = enabled;
      rgb = enabled;
      storage = enabled;
      opengl = enabled;
    };

    services = {
      avahi = enabled;
      printing = enabled;
      geoclue = enabled;

      openssh = {
        enable = true;
      };

      samba = {
        enable = true;
      };
    };

    security = {
      doas = enabled;
      keyring = enabled;
    };

    system = {
      boot = enabled;
      fonts = enabled;
      locale = enabled;
      time = enabled;
      shell = {
        zsh = enabled;
        bash = enabled;
        fish = enabled;
      };
    };

    #   IOMMU Group 24:
    # 	05:00.0 VGA compatible controller [0300]: NVIDIA Corporation GA102 [GeForce RTX 3080] [10de:2206] (rev a1)
    # 	05:00.1 Audio device [0403]: NVIDIA Corporation GA102 High Definition Audio Controller [10de:1aef] (rev a1)
    virtualisation.kvm = {
      enable = true;
      platform = "amd";

      vfioIds = [ "10de:2206" "10de:1aef" ];
    };
  };

  services.xserver.displayManager.defaultSession = "hyprland";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
