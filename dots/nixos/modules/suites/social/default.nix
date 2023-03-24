{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.suites.social;
in
{
  options.khaneliman.suites.social = with types; {
    enable = mkBoolOpt false "Whether or not to enable social configuration.";
  };

  config = mkIf cfg.enable {
    khaneliman = {
      apps = {
        discord = {
          enable = true;
          chromium = enabled;
        };
        element = enabled;
        twitter = enabled;
      };
    };
  };
}
