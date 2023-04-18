{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.desktop.addons.swayidle;
in {
  options.khanelinix.desktop.addons.swayidle = with types; {
    enable =
      mkBoolOpt false "Whether to enable swayidle in the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [swayidle];

    khanelinix.home = {
      configFile = {
        "swayidle/".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.config/swayidle";
      };
    };
  };
}
