{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.desktop.addons.swappy;
in
{
  options.khaneliman.desktop.addons.swappy = with types; {
    enable =
      mkBoolOpt false "Whether to enable Swappy in the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ swappy ];

    khaneliman.home.configFile."swappy/config".source = ./config;
    khaneliman.home.file."Pictures/screenshots/.keep".text = "";
  };
}
