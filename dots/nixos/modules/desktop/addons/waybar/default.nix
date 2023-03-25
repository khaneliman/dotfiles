{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khanelinix.desktop.addons.waybar;
in
{
  options.khanelinix.desktop.addons.waybar = with types; {
    enable =
      mkBoolOpt false "Whether to enable Waybar in the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ waybar ];

    khanelinix.home.configFile."waybar/config".source = ./config;
    khanelinix.home.configFile."waybar/style.css".source = ./style.css;
  };
}
