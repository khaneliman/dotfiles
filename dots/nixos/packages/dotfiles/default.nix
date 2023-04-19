{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "dotfiles";
  version = "2023-4-19";

  src = fetchFromGitHub {
    name = "dotfiles";
    owner = "khaneliman";
    repo = "dotfiles";
    rev = "1dbdf10b071094ef4339da4bfd883059154fcbc0";
    sha256 = "BwDbfcc/6rt2Uk6q4f87Rkfxdsr1DNIQhvs2VMzp04A=";
    fetchSubmodules = true;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';

  meta = {
    description = "Khaneliman's personal dotfiles";
    homepage = "https://github.com/khaneliman/dotfiles";
    maintainers = with lib.maintainers; [khaneliman];
  };
}
