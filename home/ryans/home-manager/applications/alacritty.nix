{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in
  lib.mkIf cfg.machine.graphics
  {
    programs.alacritty = {
      enable = true;
      package = pkgs.alacritty-graphics; # use a fork with sixel support (display images)
      settings = lib.mkMerge [
        (fromTOML (builtins.readFile ../../../../themes/alacritty/rose-pine.toml))
        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          window.blur = true;
          window.opacity = 0.8;
        })
        {
          window = {
            dynamic_padding = true;
            padding = {
              x = 10;
              y = 10;
            };
          };

          env.TERM = "xterm-256color";

          scrolling = {
            history = 10000;
            multiplier = 3;
          };

          font = let
            family = "IosevkaTerm Nerd Font Mono";
          in {
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
              inherit family;
              style = "Regular";
            };

            bold = {
              inherit family;
              style = "Bold";
            };

            italic = {
              inherit family;
              style = "Italic";
            };

            bold_italic = {
              inherit family;
              style = "Bold Italic";
            };
          };

          terminal = {
            shell = "${pkgs.fish}/bin/fish";
          };
        }
      ];
    };

    home.packages = [pkgs.nerd-fonts.iosevka-term];
  }
