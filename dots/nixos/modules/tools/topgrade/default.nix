{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.tools.topgrade;
in
{
  options.khaneliman.tools.topgrade = with types; {
    enable = mkBoolOpt false "Whether or not to enable topgrade.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      topgrade
    ];
  };
}
