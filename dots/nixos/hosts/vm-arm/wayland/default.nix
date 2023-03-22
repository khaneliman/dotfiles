{ config, pkgs, user, inputs, ... }:

{
  imports =
    (import ../../../modules/hardware) ++
    (import ../../../modules/virtualisation) ++
    [
      ../hardware-configuration.nix
      ../../../modules/fonts
    ] ++ [
      # ../../../modules/desktop/sway
      ../../../modules/desktop/hyprland
    ];

  sops.defaultSopsFile = ../../../secrets/secrets.yaml;
  users.mutableUsers = false;
  users.users.root.initialHashedPassword = "$6$0ywr8.90xfzr2.O6$4Z7GkMTiAf3dzHGeE9nUKFawVspoKLYNOGLnhNkvIf9brq5dkf5rdjx5qb8x4QWw0a4ACVU1lT0nZu1HilitP0";
  users.users.${user} = {
    initialHashedPassword = "$6$0ywr8.90xfzr2.O6$4Z7GkMTiAf3dzHGeE9nUKFawVspoKLYNOGLnhNkvIf9brq5dkf5rdjx5qb8x4QWw0a4ACVU1lT0nZu1HilitP0";
    # shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "video" "audio" ];
    packages = (with pkgs; [
      tdesktop
      qq
      feishu
      thunderbird
      blender
      dbeaver
    ]) ++ (with config.nur.repos;[
      linyinfeng.icalingua-plus-plus
    ]);
  };
  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 3;
    };
    kernelParams = [
      "quiet"
      "splash"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  environment = {
    persistence."/nix/persist" = {
      directories = [
        "/etc/nixos" # bind mounted from /nix/persist/etc/nixos to /etc/nixos
        "/etc/NetworkManager/system-connections"
        "/etc/v2raya"
        "/var/log"
        "/var/lib"
      ];
      users.${user} = {
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          ".cache"
          "Codelearning"
          ".npm-global"
          ".config"
          ".thunderbird"
          ".go-musicfox"
          "Flakes"
          "Kvm"
          { directory = ".gnupg"; mode = "0700"; }
          { directory = ".ssh"; mode = "0700"; }
          ".local"
          ".mozilla"
        ];
        files = [
          ".npmrc"
        ];
      };
    };
    systemPackages = with pkgs; [
      libnotify
      wl-clipboard
      wlr-randr
      wayland
      wayland-scanner
      wayland-utils
      egl-wayland
      wayland-protocols
      pkgs.xorg.xeyes
      glfw-wayland
      xwayland
      pkgs.qt6.qtwayland
      cinnamon.nemo
      networkmanagerapplet
      wev
      wf-recorder
      alsa-lib
      alsa-utils
      flac
      pulsemixer
      linux-firmware
      sshpass
      pkgs.rust-bin.stable.latest.default
      lxappearance
      imagemagick
      pkgs.sway-contrib.grimshot
      flameshot
      grim
    ];
  };

  services.xserver = {
    xkbOptions = "caps:escape";
  };
  console.useXkbConfig = true;

  services = {
    dbus.packages = [ pkgs.gcr ];
    getty.autologinUser = "${user}";
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  security.polkit.enable = true;
  security.sudo = {
    enable = true;
    extraConfig = ''
      ${user} ALL=(ALL) NOPASSWD:ALL
    '';
  };
  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass :wheel
    '';
  };

}
