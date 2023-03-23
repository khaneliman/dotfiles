{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.suites.video;
in
{
  options.khaneliman.suites.video = with types; {
    enable = mkBoolOpt false "Whether or not to enable video configuration.";
  };

  config = mkIf cfg.enable {
    khaneliman = {
      apps = {
        pitivi = enabled;
        obs = enabled;
      };
    };
  };
}
