{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.suites.media;
in
{
  options.khaneliman.suites.media = with types; {
    enable = mkBoolOpt false "Whether or not to enable media configuration.";
  };

  config = mkIf cfg.enable { khaneliman = { apps = { freetube = enabled; }; }; };
}
