{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khanelinix.apps.ubports-installer;
in
{
  options.khanelinix.apps.ubports-installer = with types; {
    enable = mkBoolOpt false "Whether or not to enable the UBPorts Installer.";
  };

  config =
    mkIf cfg.enable {
      environment.systemPackages = with pkgs.khanelinix; [
        ubports-installer
      ];

      services.udev.packages = with pkgs.khanelinix; [
        ubports-installer-udev-rules
      ];
    };
}
