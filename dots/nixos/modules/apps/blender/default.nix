{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.apps.blender;
in
{
  options.khaneliman.apps.blender = with types; {
    enable = mkBoolOpt false "Whether or not to enable Blender.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ blender ]; };
}
