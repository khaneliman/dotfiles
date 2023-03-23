{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.suites.emulation;
in
{
  options.khaneliman.suites.emulation = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable emulation configuration.";
  };

  config = mkIf cfg.enable {
    khaneliman = {
      apps = {
        yuzu = enabled;
        pcsx2 = enabled;
        dolphin = enabled;
      };
    };
  };
}
