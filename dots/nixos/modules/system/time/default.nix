{ options, config, pkgs, lib, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.system.time;
in
{
  options.khaneliman.system.time = with types; {
    enable =
      mkBoolOpt false "Whether or not to configure timezone information.";
  };

  config = mkIf cfg.enable { time.timeZone = "America/Chicago"; };
}
