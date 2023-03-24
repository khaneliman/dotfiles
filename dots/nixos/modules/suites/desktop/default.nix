{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.suites.desktop;
in
{
  options.khaneliman.suites.desktop = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    khaneliman = {
      desktop = {
        gnome = enabled;

        addons = { wallpapers = enabled; };
      };

      apps = {
        _1password = enabled;
        firefox = enabled;
        vlc = enabled;
        hey = enabled;
        pocketcasts = enabled;
        gparted = enabled;
      };
    };
  };
}
