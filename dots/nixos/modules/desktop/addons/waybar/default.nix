{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.desktop.addons.waybar;
in
{
  options.khaneliman.desktop.addons.waybar = with types; {
    enable =
      mkBoolOpt false "Whether to enable Waybar in the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ waybar ];

    khaneliman.home.configFile."waybar/config".source = ./config;
    khaneliman.home.configFile."waybar/style.css".source = ./style.css;
  };
}
