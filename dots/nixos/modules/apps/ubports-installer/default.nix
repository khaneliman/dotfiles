{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.ubports-installer;
in
{
  options.khaneliman.apps.ubports-installer = with types; {
    enable = mkBoolOpt false "Whether or not to enable the UBPorts Installer.";
  };

  config =
    mkIf cfg.enable {
      environment.systemPackages = with pkgs.khaneliman; [
        ubports-installer
      ];

      services.udev.packages = with pkgs.khaneliman; [
        ubports-installer-udev-rules
      ];
    };
}
