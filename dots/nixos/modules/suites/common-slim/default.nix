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
        btop = enabled;
        flake = enabled;
        glow = enabled;
        ranger = enabled;
      };

      tools = {
        atool = enabled;
        bat = enabled;
        bottom = enabled;
        comma = enabled;
        direnv = enabled;
        exa = enabled;
        fup-repl = enabled;
        git = enabled;
        lsd = enabled;
        socat = enabled;
        topgrade = enabled;
        xclip = enabled;
      };

      hardware = {
        networking = enabled;
        storage = enabled;
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
