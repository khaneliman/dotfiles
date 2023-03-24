{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.cli-apps.lazydocker;
in
{
  options.khaneliman.cli-apps.lazydocker = with types; {
    enable = mkBoolOpt false "Whether or not to enable lazydocker.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ lazydocker ]; };
}
