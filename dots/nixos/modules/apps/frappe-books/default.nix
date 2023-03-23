{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.apps.frappe-books;
in
{
  options.khaneliman.apps.frappe-books = with types; {
    enable = mkBoolOpt false "Whether or not to enable FrappeBooks.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ khaneliman.frappe-books ];
  };
}
