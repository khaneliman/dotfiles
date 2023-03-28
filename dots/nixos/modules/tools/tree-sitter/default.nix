{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.tools.tree-sitter;
in {
  options.khanelinix.tools.tree-sitter = with types; {
    enable = mkBoolOpt false "Whether or not to enable tree-sitter.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tree-sitter
    ];
  };
}
