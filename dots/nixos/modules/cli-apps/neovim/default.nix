# inputs@{ options, config, lib, pkgs, ... }:

# with lib;
# with lib.internal;
{
  inputs = {
    options = inputs.options;
    config = inputs.config;
    lib = inputs.lib;
    pkgs = inputs.pkgs;
    dotfiles.url = "github:khaneliman/dotfiles";
    nvim = {
      type = "git";
      url = "${inputs.dotfiles}/dots/shared/home/.config/nvim";
      ref = "main";
      path = "nvim";
    };
  };
  outputs = { self, nixpkgs, dotfiles, nvim }:
    let
      cfg = config.khaneliman.cli-apps.neovim;
      config = {
        home.file.".config/nvim/init.vim".text = ''
          " Your Neovim configuration here "
        '';
      };
    in
      if cfg.enable then {
        environment.systemPackages = with pkgs; [
          neovim
        ];

        environment.variables = {
          PAGER = "less";
          MANPAGER = "less";
          NPM_CONFIG_PREFIX = "$HOME/.npm-global";
          EDITOR = "nvim";
        };

        nixpkgs.config.home = {
          configFile = {
            "nvim/init.lua".text = "${dotfiles}/${nvim}/init.lua";
          };

          extraOptions = {
            # Use Neovim for Git diffs.
            programs.zsh.shellAliases.vimdiff = "nvim -d";
            programs.bash.shellAliases.vimdiff = "nvim -d";
            programs.fish.shellAliases.vimdiff = "nvim -d";
          };
        };
      } else {
        nixpkgs.config.home = {
          configFile = {
            "nvim/init.vim".text = ''
              " Your default Neovim configuration here "
            '';
          };
        };
      }
}

