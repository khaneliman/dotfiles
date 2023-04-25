{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.system.shell.fish;
  fishBasePath = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.config/fish/";
in {
  options.khanelinix.system.shell.fish = with types; {
    enable = mkBoolOpt false "Whether to enable fish.";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      fishPlugins.autopair-fish
      fishPlugins.done
      fishPlugins.fzf-fish
      fishPlugins.forgit
      # fishPlugins.fish-abbreviation-tips
      # fishPlugins.wakatime-fish
      # fishPlugins.grc
      # grc
      fishPlugins.tide
      # fishPlugins.nvm
      fishPlugins.sponge
      # fishPlugins.fish-ssh-agent
      curl
    ];

    khanelinix.home = {
      configFile = {
        "fish/config.fish".source = fishBasePath + "config.fish";
        "fish/fish_plugins".source = fishBasePath + "fish_plugins";
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
    };

    # Fisher script to install plugins
    # Add the script as a system activation script
    # system.activationScripts.install-fisher-and-plugins = {
    #   text = ''
    #     # Create a temporary fish script
    #     echo '#!/usr/bin/env fish
    #     #set -l fish_plugins_file ${config.khanelinix.home.configFile."fish/fish_plugins".source}
    #     #source $fish_plugins_file
    #     ${pkgs.curl}/bin/curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update
    #     ' > /tmp/install-fisher-and-plugins.fish
    #     chmod +x /tmp/install-fisher-and-plugins.fish

    #     # Run the fish script within a fish shell
    #     ${pkgs.fish}/bin/fish /tmp/install-fisher-and-plugins.fish

    #     # Clean up the temporary fish script
    #     rm -f /tmp/install-fisher-and-plugins.fish
    #   '';
    #   deps = ["users"];
    # };
  };
}
