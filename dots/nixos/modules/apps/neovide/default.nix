{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.apps.neovide;
in
{
  options.khaneliman.apps.neovide = with types; {
    enable = mkBoolOpt false "Whether or not to enable neovide.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ neovide ]; };
}
