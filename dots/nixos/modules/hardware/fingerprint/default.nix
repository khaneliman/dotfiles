{ options, config, pkgs, lib, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.hardware.fingerprint;
in
{
  options.khaneliman.hardware.fingerprint = with types; {
    enable = mkBoolOpt false "Whether or not to enable fingerprint support.";
  };

  config = mkIf cfg.enable { services.fprintd.enable = true; };
}
