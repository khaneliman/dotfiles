{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.system.shell.zsh;
in {
  options.khanelinix.system.shell.zsh = with types; {
    enable = mkBoolOpt false "Whether to enable zsh.";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      # interactiveShellInit = ''
      #   source ${pkgs.khanelinix.dotfiles.outPath}/dots/shared/home/.config/zsh/zshrc
      # '';
    };

    khanelinix.home = {
      file = {
        ".zshrc".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.zshrc";
        ".zshenv".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.zshenv";
        ".p10k.zsh".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.p10k.zsh";
        ".aliases".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.aliases";
        ".functions".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.functions";
      };
    };
  };
}
