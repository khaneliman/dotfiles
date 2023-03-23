{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.desktop.addons.foot;
in
{
  options.khaneliman.desktop.addons.foot = with types; {
    enable = mkBoolOpt false "Whether to enable the gnome file manager.";
  };

  config = mkIf cfg.enable {
    khaneliman.desktop.addons.term = {
      enable = true;
      pkg = pkgs.foot;
    };

    khaneliman.home.configFile."foot/foot.ini".source = ./foot.ini;
  };
}
