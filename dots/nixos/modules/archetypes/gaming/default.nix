{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.archetypes.gaming;
in
{
  options.khaneliman.archetypes.gaming = with types; {
    enable = mkBoolOpt false "Whether or not to enable the gaming archetype.";
  };

  config = mkIf cfg.enable {
    khaneliman.suites = {
      common = enabled;
      desktop = enabled;
      games = enabled;
      social = enabled;
      media = enabled;
    };
  };
}
