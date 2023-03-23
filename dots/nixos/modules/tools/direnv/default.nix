{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.tools.direnv;
in
{
  options.khaneliman.tools.direnv = with types; {
    enable = mkBoolOpt false "Whether or not to enable direnv.";
  };

  config = mkIf cfg.enable {
    khaneliman.home.extraOptions = {
      programs.direnv = {
        enable = true;
        nix-direnv = enabled;
      };
    };
  };
}
