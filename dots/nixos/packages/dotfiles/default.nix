{ lib
, stdenvNoCC
, fetchFromGitHub
,
}:
stdenvNoCC.mkDerivation {
  pname = "dotfiles";
  version = "9e688804b219c70860f470d6b6db08623e17cd08";

  src = fetchFromGitHub {
    name = "dotfiles";
    owner = "khaneliman";
    repo = "dotfiles";
    rev = "f547c4ed1af9f23bcbe0e8397b722f0800675b5f";
    sha256 = "VBARQoqDXIJ/s7AHdJSXdcsEw+/PBExe26yBaXqnkvQ=";
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
