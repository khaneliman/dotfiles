{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.tools.comma;
in
{
  options.khaneliman.tools.comma = with types; {
    enable = mkBoolOpt false "Whether or not to enable comma.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      comma
      khaneliman.nix-update-index
    ];

    khaneliman.home.extraOptions = { programs.nix-index.enable = true; };
  };
}
