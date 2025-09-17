{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  isGraphical = config.hm-options.system.graphical;
in
  mkIf isGraphical
  {
    programs.alacritty = {
      enable = true;
      package = pkgs.alacritty-graphics; # use a fork with sixel support (display images)
      settings = {
        window = {
          dynamic_padding = true;
          padding = {
            x = 5;
            y = 5;
          };
          opacity = 1;
          decorations = "none";
        };

        env.TERM = "xterm-256color";

        scrolling = {
          history = 10000;
          multiplier = 3;
        };

        colors = {
          draw_bold_text_with_bright_colors = true;

          primary = {
            background = "#222222";
            foreground = "#fff4d2";
          };

          cursor = {
            text = "#bdae93";
            cursor = "#665c54";
          };

          normal = {
            black = "#1d2021";
            red = "#cc241d";
            green = "#98971a";
            yellow = "#d79921";
            blue = "#458588";
            magenta = "#b16286";
            cyan = "#689d6a";
            white = "#a89984";
          };

          bright = {
            black = "#a89984";
            red = "#fb4934";
            green = "#b8bb26";
            yellow = "#fabd2f";
            blue = "#83a598";
            magenta = "#d3869b";
            cyan = "#8ec07c";
            white = "#fff4d2";
          };
        };

        font = {
          size = 12;

          offset = {
            x = 0;
            y = -3;
          };

          glyph_offset = {
            x = 0;
            y = -1;
          };

          normal = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "SemiBold";
          };

          bold = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "ExtraBold";
          };

          italic = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "SemiBold Italic";
          };

          bold_italic = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "ExtraBold Italic";
          };
        };

        terminal = {
          shell = "${pkgs.fish}/bin/fish";
        };
      };
    };
  }
