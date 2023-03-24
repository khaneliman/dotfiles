{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.tools.lsd;
in
{
  options.khaneliman.tools.lsd = with types; {
    enable = mkBoolOpt false "Whether or not to enable lsd.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lsd
    ];
  };
}
