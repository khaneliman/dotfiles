{ lib, stdenv, fetchzip, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "cattpuccin-macchiato-gtk";
  version = "0.4.1";

  src = fetchzip {
    url =
      "https://github.com/catppuccin/gtk/releases/download/v-0.4.1/Catppuccin-Macchiato-Standard-Blue-Dark.zip";
    sha256 = "w7yv9e9MuZgmCdr/RdDxg2hAeIhb1f82idUj4diI8v8=";
    stripRoot = false;
  };

  propagatedUserEnvPkgs = with pkgs; [
    gnome.gnome-themes-extra
    gtk-engine-murrine
  ];

  installPhase = ''
    mkdir -p $out/share/themes/
    cp -r Catppuccin-Macchiato-Standard-Blue $out/share/themes
  '';

  meta = {
    description = "Soothing pastel theme for GTK3";
    homepage = "https://github.com/catppuccin/gtk";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.Ruixi-rebirth ];
  };
}
