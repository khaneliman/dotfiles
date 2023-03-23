{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.suites.common-slim;
in
{
  options.khaneliman.suites.common-slim = with types; {
    enable = mkBoolOpt false "Whether or not to enable common-slim configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.khaneliman.list-iommu
    ];

    khaneliman = {
      nix = enabled;

      cli-apps = {
        flake = enabled;
      };

      tools = {
        git = enabled;
        fup-repl = enabled;
        comma = enabled;
        bottom = enabled;
        direnv = enabled;
      };

      hardware = {
        storage = enabled;
        networking = enabled;
      };

      services = {
        openssh = enabled;
        tailscale = enabled;
      };

      security = {
        doas = enabled;
      };

      system = {
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
  };
}
