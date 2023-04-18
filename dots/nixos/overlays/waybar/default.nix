{channels, ...}: final: prev: {
  khanelinix =
    (prev.khanelinix or {})
    // {
      waybar = with prev;
        super.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
        });
    };
}
