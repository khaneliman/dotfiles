{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.desktop.addons.qt;
in {
  options.khanelinix.desktop.addons.qt = with types; {
    enable = mkBoolOpt false "Whether to customize qt and apply themes.";
    theme = {
      name =
        mkOpt str "Catppuccin-Macchiato-Blue"
        "The name of the kvantum theme to apply.";
      pkg = mkOpt package pkgs.khanelinix.catppuccin-kvantum "The package to use for the theme.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.theme.pkg
      libsForQt5.qtstyleplugin-kvantum
    ];

    environment.sessionVariables = lib.mkForce {
      "QT_STYLE_OVERRIDE" = "kvantum";
    };

    khanelinix.home.extraOptions = {
      qt = {
        enable = true;

        platformTheme = "gtk";

        style = {
          name = cfg.theme.name;
          package = cfg.theme.pkg;
        };
      };
    };
  };
}
