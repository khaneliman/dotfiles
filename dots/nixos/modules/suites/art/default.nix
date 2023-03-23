{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.suites.art;
in
{
  options.khaneliman.suites.art = with types; {
    enable = mkBoolOpt false "Whether or not to enable art configuration.";
  };

  config = mkIf cfg.enable {
    khaneliman = {
      apps = {
        gimp = enabled;
        inkscape = enabled;
        blender = enabled;
      };
    };
  };
}
