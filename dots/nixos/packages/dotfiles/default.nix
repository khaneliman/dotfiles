{ lib
, stdenvNoCC
, fetchFromGitHub
,
}:
stdenvNoCC.mkDerivation {
  pname = "dotfiles";
  version = "2023-4-28";

  src = fetchFromGitHub {
    name = "dotfiles";
    owner = "khaneliman";
    repo = "dotfiles";
    rev = "adf912881de5ab00f7459064235b51f09c618073";
    sha256 = "NRti8KqYUiZqqW12p+hHt/uGDrueR7vv9uE8d/Qja6E=";
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
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
