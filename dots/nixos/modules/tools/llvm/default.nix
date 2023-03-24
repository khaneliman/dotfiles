{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.tools.llvm;
in
{
  options.khaneliman.tools.llvm = with types; {
    enable = mkBoolOpt false "Whether or not to enable llvm.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      llvm
    ];
  };
}
