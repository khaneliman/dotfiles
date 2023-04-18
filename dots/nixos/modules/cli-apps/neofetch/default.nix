{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.cli-apps.neofetch;
in {
  options.khanelinix.cli-apps.neofetch = with types; {
    enable = mkBoolOpt false "Whether or not to enable neofetch.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [neofetch];

    khanelinix.home = {
      configFile = {
        "neofetch/".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.config/neofetch";
      };
    };
  };
}
