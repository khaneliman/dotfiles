{ config, lib, pkgs, ... }:

let
  cfg = config.khaneliman.tools.icehouse;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.khaneliman.tools.icehouse = {
    enable = mkEnableOption "Icehouse";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.snowfallorg.icehouse ];
  };
}
