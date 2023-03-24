{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.tools.atool;
in
{
  options.khaneliman.tools.atool = with types; {
    enable = mkBoolOpt false "Whether or not to enable atool.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ atool ]; };
}
