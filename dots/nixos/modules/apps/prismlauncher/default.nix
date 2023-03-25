{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khanelinix.apps.prismlauncher;
in
{
  options.khanelinix.apps.prismlauncher = with types; {
    enable = mkBoolOpt false "Whether or not to enable Prism Launcher.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ prismlauncher ]; };
}
