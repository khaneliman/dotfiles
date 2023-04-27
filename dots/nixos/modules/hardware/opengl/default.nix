{ options
, config
, pkgs
, lib
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.hardware.opengl;
in
{
  options.khanelinix.hardware.opengl = with types; {
    enable =
      mkBoolOpt false
        "Whether or not to enable support for opengl.";
  };

  config = mkIf cfg.enable {
    hardware.opengl =
      {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
          libva1
        ];
      };
  };
}
