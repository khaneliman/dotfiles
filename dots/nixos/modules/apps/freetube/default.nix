{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.freetube;
in
{
  options.khaneliman.apps.freetube = with types; {
    enable = mkBoolOpt false "Whether or not to enable FreeTube.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ freetube ]; };
}
