{ options, config, lib, pkgs, ... }:
with lib;
with lib.internal;
let cfg = config.khaneliman.archetypes.vm;
in
{
  options.khaneliman.archetypes.vm = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the vm archetype.";
  };

  config = mkIf cfg.enable {
    khaneliman = {
      suites = {
        desktop = enabled;
        development = enabled;
        vm = enabled;
      };

      tools = {
        appimage-run = enabled;
      };
    };
  };
}
