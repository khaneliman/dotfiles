{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.desktop.addons.waybar;
in
{
  options.khanelinix.desktop.addons.waybar = with types; {
    enable =
      mkBoolOpt false "Whether to enable Waybar in the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ waybar-hyprland ];

    khanelinix.home.configFile = mkMerge [
      (mkIf config.khanelinix.desktop.sway.enable {
        "waybar/config".source = ./sway/config;
        "waybar/style.css".source = ./sway/style.css;
      })
      (mkIf config.khanelinix.desktop.hyprland.enable {
        "waybar/scripts".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.config/waybar/scripts";
        "waybar/default-modules.jsonc".source = ./hyprland/default-modules.jsonc;
        "waybar/config.jsconc".source = ./hyprland/config.jsonc;
        "waybar/macchiato.css".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.config/waybar/macchiato.css";
        "waybar/style.css".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.config/waybar/style.css";
      })
    ];
  };
}
