{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.etcher;
in
{
  options.khaneliman.apps.etcher = with types; {
    enable = mkBoolOpt false "Whether or not to enable etcher.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        # Etcher is currently broken in nixpkgs, temporarily replaced with
        # gnome disk utility.
        # etcher
        gnome.gnome-disk-utility
      ];
  };
}
