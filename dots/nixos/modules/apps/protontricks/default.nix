{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.apps.protontricks;
in {
  options.khanelinix.apps.protontricks = with types; {
    enable = mkBoolOpt false "Whether or not to enable Protontricks.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [protontricks];
  };
}
