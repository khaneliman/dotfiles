{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.archetypes.server;
in
{
  options.khaneliman.archetypes.server = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the server archetype.";
  };

  config = mkIf cfg.enable {
    khaneliman = {
      suites = {
        common-slim = enabled;
      };

      cli-apps = {
        neovim = enabled;
        tmux = enabled;
      };
    };
  };
}
