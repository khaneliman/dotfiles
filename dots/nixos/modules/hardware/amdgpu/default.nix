{ options
, config
, pkgs
, lib
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.hardware.amdgpu;
  kernelModules = lib.mkDefault config.boot.availableKernelModules;
  videoDrivers = lib.mkDefault config.services.xserver.videoDrivers;
in
{
  options.khanelinix.hardware.amdgpu = with types; {
    enable =
      mkBoolOpt false
        "Whether or not to enable support for amdgpu.";
  };

  config = mkIf cfg.enable {
    # TODO: conditionally add kernel module and video drivers
    # boot.availableKernelModules = [ "amdgpu" ] ++ kernelModules;
    environment.systemPackages = with pkgs; [ radeontop ];
    # services.videoDrivers = [ "amdgpu" ] ++ videoDrivers;
  };
}
