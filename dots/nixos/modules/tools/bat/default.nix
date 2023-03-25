{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khanelinix.tools.bat;
in
{
  options.khanelinix.tools.bat = with types; {
    enable = mkBoolOpt false "Whether or not to enable bat.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bat
    ];
  };
}
