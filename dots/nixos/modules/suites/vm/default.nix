{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.suites.vm;
in
{
  options.khaneliman.suites.vm = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable common vm configuration.";
  };

  config = mkIf cfg.enable {

    khaneliman = {
    
      apps = {
      };

      cli-apps = {
      };

      services = { 
        spice-vdagentd = enabled;
        spice-webdav = enabled;
      };

      tools = {
        at = enabled;
        direnv = enabled;
        go = enabled;
        http = enabled;
        k8s = enabled;
        node = enabled;
        qmk = enabled;
      };

      virtualisation = { };
    };
  };
}
