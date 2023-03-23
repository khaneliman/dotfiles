{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.cli-apps.wshowkeys;
in
{
  options.khaneliman.cli-apps.wshowkeys = with types; {
    enable = mkBoolOpt false "Whether or not to enable wshowkeys.";
  };

  config = mkIf cfg.enable {
    khaneliman.user.extraGroups = [ "input" ];
    environment.systemPackages = with pkgs; [ wshowkeys ];
  };
}
