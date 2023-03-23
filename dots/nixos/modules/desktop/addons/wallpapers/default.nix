{ options, config, pkgs, lib, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.desktop.addons.wallpapers;
  inherit (pkgs.khaneliman) wallpapers;
in
{
  options.khaneliman.desktop.addons.wallpapers = with types; {
    enable = mkBoolOpt false
      "Whether or not to add wallpapers to ~/Pictures/wallpapers.";
  };

  config = {
    khaneliman.home.file = lib.foldl
      (acc: name:
        let wallpaper = wallpapers.${name};
        in
        acc // {
          "Pictures/wallpapers/${wallpaper.fileName}".source = wallpaper;
        })
      { }
      (wallpapers.names);
  };
}
