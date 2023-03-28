{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.cli-apps.ranger;
in {
  options.khanelinix.cli-apps.ranger = with types; {
    enable = mkBoolOpt false "Whether or not to enable ranger.";
  };

  config =
    mkIf cfg.enable {environment.systemPackages = with pkgs; [ranger];};
}
