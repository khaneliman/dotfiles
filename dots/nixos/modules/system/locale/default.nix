{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.system.locale;
in {
  options.khanelinix.system.locale = with types; {
    enable = mkBoolOpt false "Whether or not to manage locale settings.";
  };

  config = mkIf cfg.enable {
    i18n = {
      inputMethod = {
        enabled = "fcitx5";
      };
      defaultLocale = "en_US.UTF-8";
      supportedLocales = ["en_US.UTF-8/UTF-8"];
    };

    console = {
      keyMap = mkForce "us";
      font = "Lat2-Terminus16";
    };
  };
}
