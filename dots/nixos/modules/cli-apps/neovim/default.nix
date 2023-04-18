inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.cli-apps.neovim;
in {
  options.khanelinix.cli-apps.neovim = with lib.types; {
    enable = lib.mkEnableOption "neovim";
    # configDir = lib.mkOption {
    #   type = path;
    #   default = builtins.path {
    #     path = ~/.config/.dotfiles/shared/home/.config/nvim;
    #     # path = ./config;
    #   };
    #   description = "Path to the neovim configuration directory.";
    # };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      neovim
    ];

    environment.variables = {
      PAGER = "less";
      MANPAGER = "less";
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      EDITOR = "nvim";
    };

    khanelinix.home = {
      configFile = {
        "nvim/".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.config/nvim";
      };

      extraOptions = {
        # Use Neovim for Git diffs.
        programs.zsh.shellAliases.vimdiff = "nvim -d";
        programs.bash.shellAliases.vimdiff = "nvim -d";
        programs.fish.shellAliases.vimdiff = "nvim -d";
      };
    };
  };
}
