{ options
, config
, lib
, pkgs
, inputs
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.system.shell.fish;
  fishBasePath = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.config/fish/";
in
{
  options.khanelinix.system.shell.fish = with types; {
    enable = mkBoolOpt false "Whether to enable fish.";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
    };

    khanelinix.home = {
      configFile = {
        # TODO: make sure all equivalent functionality is reproduced in nix config
        # "fish/config.fish".source = fishBasePath + "config.fish";
        # "fish/fish_plugins".source = fishBasePath + "fish_plugins";
        "fish/fish_plugins".text = builtins.readFile (fishBasePath + "fish_plugins");
        "fish/themes".source = fishBasePath + "themes/";
        "fish/conf.d/environment_variables.fish".source = fishBasePath + "conf.d/environment_variables.fish";
        "fish/conf.d/fish_variables.fish".source = fishBasePath + "conf.d/fish_variables.fish";
        "fish/functions/bak.fish".source = fishBasePath + "functions/bak.fish";
        "fish/functions/cd.fish".source = fishBasePath + "functions/cd.fish";
        "fish/functions/clear.fish".source = fishBasePath + "functions/clear.fish";
        "fish/functions/ex.fish".source = fishBasePath + "functions/ex.fish";
        "fish/functions/git.fish".source = fishBasePath + "functions/git.fish";
        "fish/functions/load_ssh.fish".source = fishBasePath + "functions/load_ssh.fish";
        "fish/functions/mkcd.fish".source = fishBasePath + "functions/mkcd.fish";
        "fish/functions/mvcd.fish".source = fishBasePath + "functions/mvcd.fish";
        "fish/functions/ranger.fish".source = fishBasePath + "functions/ranger.fish";
      };

      file = {
        ".aliases".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.aliases";
      };

      extraOptions = {
        programs.fish = {
          enable = true;
          loginShellInit = ''
          '';
          interactiveShellInit = ''
            set fish_greeting # Disable greeting
            fastfetch
          '';
          plugins = [
            # Enable a plugin (here grc for colorized command output) from nixpkgs
            # { name = "grc"; src = pkgs.fishPlugins.grc.src; }
            { name = "autopair-fish"; src = pkgs.fishPlugins.autopair-fish.src; }
            { name = "done"; src = pkgs.fishPlugins.done.src; }
            { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
            { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
            { name = "tide"; src = pkgs.fishPlugins.tide.src; }
            { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
            # Manually packaging and enable a plugin
            {
              name = "fisher";
              src = pkgs.fetchFromGitHub {
                owner = "jorgebucaran";
                repo = "fisher";
                rev = "4.4.3";
                hash = "sha256-q9Yi6ZlHNFnPN05RpO+u4B5wNR1O3JGIn2AJ3AEl4xs=";
              };
            }
          ];
        };
      };
    };
  };
}
