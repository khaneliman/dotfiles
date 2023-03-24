{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.cli-apps.lazygit;
in
{
  options.khaneliman.cli-apps.lazygit = with types; {
    enable = mkBoolOpt false "Whether or not to enable lazygit.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ lazygit ]; };
}
