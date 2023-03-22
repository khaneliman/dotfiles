{
  description = "My Personal NixOS Configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
      rust-overlay.url = "github:oxalica/rust-overlay";
      impermanence.url = "github:nix-community/impermanence";
      nur.url = "github:nix-community/NUR";
      hyprpicker.url = "github:hyprwm/hyprpicker";
      hypr-contrib.url = "github:hyprwm/contrib";
      flake-utils.url = "github:numtide/flake-utils";
      sops-nix.url = "github:Mic92/sops-nix";
      picom.url = "github:yaocccc/picom";
      hyprland.url = "github:hyprwm/Hyprland";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    let
      user = "khaneliman";
      domain = "khaneliman.top";
      selfPkgs = import ./pkgs;
    in
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux"]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
            ];
          };
        in
        {
          devShells = {
            #run by `nix devlop` or `nix-shell`(legacy)
            default = import ./shell.nix { inherit pkgs; };
            #run by `nix devlop .#<name>`
            secret = with pkgs; mkShell {
              name = "secret";
              nativeBuildInputs = [
                sops
                age
                ssh-to-age
                ssh-to-pgp
              ];
              shellHook = ''
                export PS1="\e[0;31m(Secret)\$ \e[m" 
              '';
            };
          };
        }
      )
      overlays.default = selfPkgs.overlay;
      nixosConfigurations = (
        # NixOS configurations
        import ./hosts {
          # Imports ./hosts/default.nix
          inherit nixpkgs self inputs user;
        }
      );
    };
}
