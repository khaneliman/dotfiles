{ options, config, pkgs, lib, ... }:

with lib;
with lib.internal;
let cfg = config.khaneliman.hardware.storage;
in
{
  options.khaneliman.hardware.storage = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable support for extra storage devices.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ntfs3g fuseiso ];
  };
}
