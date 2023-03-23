{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.suites.games;
  apps = {
    steam = enabled;
    prismlauncher = enabled;
    lutris = enabled;
    winetricks = enabled;
    protontricks = enabled;
    bottles = enabled;
  };
  cli-apps = {
    wine = enabled;
    proton = enabled;
  };
in
{
  options.khaneliman.suites.games = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common games configuration.";
  };

  config = mkIf cfg.enable { khaneliman = { inherit apps cli-apps; }; };
}
