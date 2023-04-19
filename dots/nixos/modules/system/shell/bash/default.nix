{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.system.shell.bash;
in {
  options.khanelinix.system.shell.bash = with types; {
    enable = mkBoolOpt false "Whether to enable bash.";
  };

  config = mkIf cfg.enable {
    # programs.bash = {
    #   enable = true;
    #   # interactiveShellInit = ''
    #   #   source ${pkgs.khanelinix.dotfiles.outPath}/dots/shared/home/.config/bash/bashrc
    #   # '';
    # };

    khanelinix.home = {
      file = {
        ".bashrc".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.bashrc";
        ".bashenv".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.bashenv";
        ".aliases".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.aliases";
        ".functions".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.functions";
      };
    };
  };
}
