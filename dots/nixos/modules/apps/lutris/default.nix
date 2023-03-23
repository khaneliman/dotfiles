{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.lutris;
in
{
  options.khaneliman.apps.lutris = with types; {
    enable = mkBoolOpt false "Whether or not to enable Lutris.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
      # Needed for some installers like League of Legends
      openssl
      gnome.zenity
    ];
  };
}
