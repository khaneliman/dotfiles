{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.desktop.addons.wofi;
in
{
  options.khaneliman.desktop.addons.wofi = with types; {
    enable =
      mkBoolOpt false "Whether to enable the Wofi in the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wofi wofi-emoji ];

    # config -> .config/wofi/config
    # css -> .config/wofi/style.css
    # colors -> $XDG_CACHE_HOME/wal/colors
    # khaneliman.home.configFile."foot/foot.ini".source = ./foot.ini;
    khaneliman.home.configFile."wofi/config".source = ./config;
    khaneliman.home.configFile."wofi/style.css".source = ./style.css;
  };
}
