{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.tools.appimage-run;
in
{
  options.khaneliman.tools.appimage-run = with types; {
    enable = mkBoolOpt false "Whether or not to enable appimage-run.";
  };

  config = mkIf cfg.enable {
    khaneliman.home.configFile."wgetrc".text = "";

    environment.systemPackages = with pkgs; [
      appimage-run
    ];
  };
}
