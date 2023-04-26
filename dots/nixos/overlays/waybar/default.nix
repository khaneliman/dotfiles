{ channels, ... }: final: prev: {
  khanelinix =
    (prev.khanelinix or { })
    // {
      waybar-hyprland = prev.override {
        version = "757f20fc04d735985f5dd8b20e8852f9cb163401";
        hash = "sha256-cv81WUDNGeVbm8F6fHtfH/DRDIh1dq5AFlnkQz1KpX8=";
      };
    };
}

