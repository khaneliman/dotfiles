{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.internal; let
  inherit (pkgs.khanelinix) wallpapers;
in {
  options.khanelinix.desktop.addons.wallpapers = with types; {
    enable =
      mkBoolOpt false
      "Whether or not to add wallpapers to ~/Pictures/wallpapers.";
  };

  config = {
    khanelinix.home.file =
      lib.foldl
      (acc: name: let
        wallpaper = wallpapers.${name};
      in
        acc
        // {
          "Pictures/wallpapers/${wallpaper.fileName}".source = wallpaper;
        })
      {}
      (wallpapers.names);
  };
}
