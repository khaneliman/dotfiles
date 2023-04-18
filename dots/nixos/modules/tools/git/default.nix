{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.tools.git;
  gpg = config.khanelinix.security.gpg;
  user = config.khanelinix.user;
in {
  options.khanelinix.tools.git = with types; {
    enable = mkBoolOpt false "Whether or not to install and configure git.";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
    signingKey =
      mkOpt types.str "9762169A1B35EA68" "The key ID to sign commits with.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [git];

    khanelinix.home.file = {
      ".gitconfig".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.gitconfig";
      ".gitconfig.functions".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.gitconfig.functions";
      # ".gitconfig.signing".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.gitconfig.signing"; # TODO: handle secrets
      ".gitignore_global".source = pkgs.khanelinix.dotfiles.outPath + "/dots/shared/home/.gitignore_global";
      ".gitconfig.local".source = pkgs.khanelinix.dotfiles.outPath + "/dots/linux/hyprland/home/.gitconfig.local";
    };

    khanelinix.home.extraOptions = {
      programs.git = {
        enable = true;
        inherit (cfg) userName userEmail;
        lfs = enabled;
        signing = {
          key = cfg.signingKey;
          signByDefault = mkIf gpg.enable true;
        };
      };
    };
  };
}
