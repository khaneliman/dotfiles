{ options, config, pkgs, lib, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.tools.at;
in
{
  options.khaneliman.tools.at = with types; {
    enable = mkBoolOpt false "Whether or not to install at.";
    pkg = mkOpt package pkgs.khaneliman.at "The package to install as at.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.pkg
    ];
  };
}
