{ config, pkgs, ... }:
{
  services.dunst = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      size = "32x32";
    };
    settings = {
      global = {
        follow = "mouse";
        width = 256;
        height = 222;
        origin = "top-right";
        offset = "25x50";
        progress_bar_height = 5;
        progress_bar_min_width = 0;
        progress_bar_max_width = 444;
        progress_bar_frame_width = 0;
        transparency = 3;
        horizontal_padding = 11;
        frame_width = 6;
        frame_color = "#3b4252";
        gap_size = 8;
        separator_color = "#404859";
        idle_threshold = 120;
        font = "mplus Nerd Font 10";
        format = "<span size='x-large' font_desc='Cantarell,mplus Nerd Font 9' weight='bold' foreground='#f9f9f9'>%s</span>\n%b";
        show_age_threshold = 60;
        icon_position = "left";
        min_icon_size = 48;
        max_icon_size = 80;
        enable_recursive_icon_lookup = true;
        icon_theme = "Papirus-Dark";
        sticky_history = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "context_all";
        mouse_right_click = "close_all";
        alignment = "center";
        markup = "full";
        always_run_script = true;
        corner_radius = 8;
      };
      urgency_low = {
        timeout = 3;
        background = "#3b4252";
        foreground = "#f9f9f9";
        highlight = "#f48ee8";
      };
      urgency_normal = {
        timeout = 6;
        background = "#3b4252";
        foreground = "#f9f9f9";
        highlight = "#f48ee8";
      };
      urgency_critical = {
        timeout = 0;
        background = "#3b4252";
        foreground = "#f9f9f9";
        highlight = "#f48ee8";
      };
    };
  };
}
