{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.apps.firefox;
  defaultSettings = {
    "browser.aboutwelcome.enabled" = false;
    "browser.meta_refresh_when_inactive.disabled" = true;
    "browser.startup.homepage" = "https://start.duckduckgo.com/?kak=-1&kal=-1&kao=-1&kaq=-1&kt=Hack+Nerd+Font&kae=d&ks=m&k7=2e3440&kj=3b4252&k9=eceff4&kaa=d8dee9&ku=1&k8=d8dee9&kx=81a1c1&k21=3b4252&k18=1&k5=2&kp=-2&k1=-1&kaj=u&kay=b&kk=-1&kax=-1&kap=-1&kau=-1";
    "browser.bookmarks.showMobileBookmarks" = true;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.ssb.enabled" = true;
  };
in {
  options.khanelinix.apps.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
    extraConfig =
      mkOpt str "" "Extra configuration for the user profile JS file.";
    userChrome =
      mkOpt str "" "Extra configuration for the user chrome CSS file.";
    settings = mkOpt attrs defaultSettings "Settings to apply to the profile.";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-browser-connector.enable = config.khanelinix.desktop.gnome.enable;

    khanelinix.home = {
      file = {
        ".mozilla/native-messaging-hosts/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/lib/mozilla/native-messaging-hosts/com.dannyvankooten.browserpass.json";

        ".mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = mkIf config.khanelinix.desktop.gnome.enable "${pkgs.chrome-gnome-shell}/lib/mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
      };

      extraOptions = {
        programs.firefox = {
          enable = true;
          package = pkgs.firefox.override {
            cfg = {
              enableBrowserpass = true;
              enableGnomeExtensions = config.khanelinix.desktop.gnome.enable;
            };

            extraNativeMessagingHosts =
              optional
              config.khanelinix.desktop.gnome.enable
              pkgs.gnomeExtensions.gsconnect;
          };

          profiles.${config.khanelinix.user.name} = {
            inherit (cfg) extraConfig userChrome settings;
            id = 0;
            name = config.khanelinix.user.name;
          };
        };
      };
    };
  };
}
