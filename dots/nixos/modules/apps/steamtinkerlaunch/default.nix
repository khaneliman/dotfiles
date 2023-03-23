{ lib, pkgs, config, ... }:

let
  cfg = config.khaneliman.apps.steamtinkerlaunch;

  inherit (lib) mkIf mkEnableOption;
in
{
  options.khaneliman.apps.steamtinkerlaunch = {
    enable = mkEnableOption "Steam Tinker Launch";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steamtinkerlaunch
    ];
  };
}
