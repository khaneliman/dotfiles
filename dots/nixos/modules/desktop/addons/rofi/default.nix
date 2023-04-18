{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.desktop.addons.rofi;
in {
  options.khanelinix.desktop.addons.rofi = with types; {
    enable =
      mkBoolOpt false "Whether to enable Rofi in the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [rofi];

    khanelinix.home = {
      configFile = {
        "rofi/".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.config/rofi";
      };
    };
  };
}
