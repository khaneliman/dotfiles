{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.pocketcasts;
in
{
  options.khaneliman.apps.pocketcasts = with types; {
    enable = mkBoolOpt false "Whether or not to enable Pocketcasts.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.khaneliman; [ pocketcasts ];
  };
}
