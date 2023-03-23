{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.element;
in
{
  options.khaneliman.apps.element = with types; {
    enable = mkBoolOpt false "Whether or not to enable Element.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ element-desktop ];
  };
}
