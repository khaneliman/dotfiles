{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.internal; {
  imports = [./hardware.nix];

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

    cli-apps = {
    };

    desktop = {
      hyprland = {
        enable = true;
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
      audio = enabled;
      networking = enabled;
      storage = enabled;
    };

    services = {
      avahi = enabled;
      printing = enabled;

      samba = {
        enable = true;

        shares = {
          video = {
            path = "/mnt/games";
            public = true;
            read-only = true;
          };
          audio = {
            path = "/mnt/steam";
            public = true;
            read-only = true;
          };
        };
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

      vfioIds = ["10de:2206" "10de:1aef"];
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
