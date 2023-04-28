{ options
, config
, pkgs
, lib
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.hardware.amdgpu;
in
{
  options.khanelinix.hardware.amdgpu = with types; {
    enable =
      mkBoolOpt false
        "Whether or not to enable support for amdgpu.";
  };

  config = mkIf cfg.enable {
    # TODO: conditionally add kernel module and video drivers
    # boot.availableKernelModules = [ "amdgpu" ];
    # services.videoDrivers = [ "amdgpu" ];

    environment.systemPackages = with pkgs; [ radeontop ];

    environment.variables = {
      # VAAPI and VDPAU config for accelerated video.
      # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
      "VDPAU_DRIVER" = "radeonsi";
      "LIBVA_DRIVER_NAME" = "radeonsi";
    };
  };
}
