{ lib
, stdenvNoCC
, fetchFromGitHub
,
}:
stdenvNoCC.mkDerivation rec {
  pname = "dotfiles";
  version = "2927c7225a1f0d6b13713f80b8added05c478d73";

  src = fetchFromGitHub {
    name = "dotfiles";
    owner = "khaneliman";
    repo = "dotfiles";
    rev = "2927c7225a1f0d6b13713f80b8added05c478d73";
    sha256 = "mnBbvfbxw2FE3f8P5BGmFilDvM0hkbiPqyCs2KQXTNE=";
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
