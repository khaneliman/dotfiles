function flakify
    if not test -e flake.nix
        nix flake new -t github:nix-community/nix-direnv .
    else if not test -e .envrc
        echo "use flake" >.envrc
        direnv allow
    end
    eval (env $EDITOR "flake.nix")
end

