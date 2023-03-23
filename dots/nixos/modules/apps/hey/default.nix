{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.hey;
in
{
  options.khaneliman.apps.hey = with types; {
    enable = mkBoolOpt false "Whether or not to enable HEY.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs.khaneliman; [ hey ]; };
}
