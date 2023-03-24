{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.tools.exa;
in
{
  options.khaneliman.tools.exa = with types; {
    enable = mkBoolOpt false "Whether or not to enable exa.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      exa
    ];
  };
}
