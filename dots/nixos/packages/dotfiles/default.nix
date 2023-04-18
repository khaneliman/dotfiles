{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "dotfiles";
  version = "2023-4-17";

  src = fetchFromGitHub {
    name = "dotfiles";
    owner = "khaneliman";
    repo = "dotfiles";
    rev = "959ce1e6cdcec614174b289ce0bed5e7a33130a0";
    sha256 = "YEgJosDwi0AJ0HR2SRWKnPo75UhNcUpEqmJpNO2W0fo=";
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
