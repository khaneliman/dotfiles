{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.twitter;
in
{
  options.khaneliman.apps.twitter = with types; {
    enable = mkBoolOpt false "Whether or not to enable Twitter.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs.khaneliman; [ twitter ]; };
}
