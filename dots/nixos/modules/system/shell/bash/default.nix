{ options
, config
, lib
, pkgs
, inputs
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.system.shell.bash;
in
{
  options.khanelinix.system.shell.bash = with types; {
    enable = mkBoolOpt false "Whether to enable bash.";
  };

  config = mkIf cfg.enable {
    # programs.bash = {
    #   enable = true;
    #   # interactiveShellInit = ''
    #   #   source ${inputs.dotfiles.outPath}/dots/shared/home/.config/bash/bashrc
    #   # '';
    # };

    khanelinix.home = {
      file = {
        ".bashrc".source = inputs.dotfiles.outPath + "/dots/shared/home/.bashrc";
        ".bashenv".source = inputs.dotfiles.outPath + "/dots/shared/home/.bashenv";
        ".aliases".source = inputs.dotfiles.outPath + "/dots/shared/home/.aliases";
        ".functions".source = inputs.dotfiles.outPath + "/dots/shared/home/.functions";
      };
    };
  };
}
