{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.yt-music;
in
{
  options.khaneliman.apps.yt-music = with types; {
    enable = mkBoolOpt false "Whether or not to enable YouTube Music.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs.khaneliman; [ yt-music ]; };
}
