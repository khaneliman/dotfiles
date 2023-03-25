{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khanelinix.apps.frappe-books;
in
{
  options.khanelinix.apps.frappe-books = with types; {
    enable = mkBoolOpt false "Whether or not to enable FrappeBooks.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ khanelinix.frappe-books ];
  };
}
