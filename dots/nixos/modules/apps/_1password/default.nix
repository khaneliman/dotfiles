{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.apps._1password;
in {
  options.khanelinix.apps._1password = with types; {
    enable = mkBoolOpt false "Whether or not to enable 1password.";
  };

  config = mkIf cfg.enable {
    programs = {
      _1password = enabled;
      _1password-gui = {
        enable = true;

        polkitPolicyOwners = [config.khanelinix.user.name];
      };
    };
  };
}
