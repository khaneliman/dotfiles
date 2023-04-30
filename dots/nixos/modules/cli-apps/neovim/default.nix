inputs @ { options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.cli-apps.neovim;
in
{
  options.khanelinix.cli-apps.neovim = with lib.types; {
    enable = lib.mkEnableOption "neovim";
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
        "astronvim/lua/user/".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.config/astronvim/lua/user";
      };

      extraOptions = {
        # Use Neovim for Git diffs.
        programs.zsh.shellAliases.vimdiff = "nvim -d";
        programs.bash.shellAliases.vimdiff = "nvim -d";
        programs.fish.shellAliases.vimdiff = "nvim -d";
        home.shellAliases = {
          vim = "nvim";
        };
      };
    };
  };
}
