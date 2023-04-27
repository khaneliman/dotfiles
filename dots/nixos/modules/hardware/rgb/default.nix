{ options
, config
, pkgs
, lib
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.hardware.rgb;
in
{
  options.khanelinix.hardware.rgb = with types;
    {
      enable =
        mkBoolOpt false
          "Whether or not to enable support for rgb controls.";
      motherboard = mkOption {
        type = types.nullOr (types.enum [ "amd" "intel" ]);
        default = "amd";
        description = lib.mdDoc "CPU family of motherboard. Allows for addition motherboard i2c support.";
      };
    };

  config = mkIf cfg.enable {
    hardware.ckb-next.enable = true;
    services.hardware.openrgb = {
      enable = true;
      motherboard = cfg.motherboard;
    };

    environment.systemPackages = with pkgs; [ openrgb-with-all-plugins i2c-tools ];
  };
}
