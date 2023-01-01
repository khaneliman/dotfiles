function cd --description 'change directory and run onefetch if a git directory' 
    if test -n "$argv"
        builtin cd "$argv";
    else 
        builtin cd;
    end

    git rev-parse 2>/dev/null;

    if test $status -eq 0
        if test -z "$LAST_REPO" -o "$LAST_REPO" != $(basename $(git rev-parse --show-toplevel)) 
            onefetch
            set -g LAST_REPO $(basename $(git rev-parse --show-toplevel))
        end
    end
end
