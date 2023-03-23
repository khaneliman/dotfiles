{ options, config, pkgs, lib, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.services.printing;
in
{
  options.khaneliman.services.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing support.";
  };

  config = mkIf cfg.enable { services.printing.enable = true; };
}
