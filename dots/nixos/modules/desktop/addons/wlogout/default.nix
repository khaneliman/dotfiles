{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.desktop.addons.wlogout;
in {
  options.khanelinix.desktop.addons.wlogout = with types; {
    enable =
      mkBoolOpt false "Whether to enable wlogout in the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [wlogout];

    khanelinix.home = {
      configFile = {
        "wlogout/".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.config/wlogout";
      };
    };
  };
}
