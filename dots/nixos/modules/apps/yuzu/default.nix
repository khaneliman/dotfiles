{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.yuzu;
in
{
  options.khaneliman.apps.yuzu = with types; {
    enable = mkBoolOpt false "Whether or not to enable Yuzu.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ yuzu-mainline ];
  };
}
