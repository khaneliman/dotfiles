{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.tools.xclip;
in
{
  options.khaneliman.tools.xclip = with types; {
    enable = mkBoolOpt false "Whether or not to enable xclip.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xclip
    ];
  };
}
