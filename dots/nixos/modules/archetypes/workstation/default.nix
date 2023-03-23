{ options, config, lib, pkgs, ... }:
with lib;
with lib.internal;
let cfg = config.khaneliman.archetypes.workstation;
in
{
  options.khaneliman.archetypes.workstation = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the workstation archetype.";
  };

  config = mkIf cfg.enable {
    khaneliman = {
      suites = {
        common = enabled;
        desktop = enabled;
        development = enabled;
        art = enabled;
        video = enabled;
        social = enabled;
        media = enabled;
      };

      tools = {
        appimage-run = enabled;
      };
    };
  };
}
