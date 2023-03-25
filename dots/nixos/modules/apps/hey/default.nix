{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khanelinix.apps.hey;
in
{
  options.khanelinix.apps.hey = with types; {
    enable = mkBoolOpt false "Whether or not to enable HEY.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs.khanelinix; [ hey ]; };
}
