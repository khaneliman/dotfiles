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
    rev = "9e688804b219c70860f470d6b6db08623e17cd08";
    sha256 = "qdWfa27+kF5AAeNMHGx8AI6yHIhLNgqZgF4EdlE6kJc=";
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
