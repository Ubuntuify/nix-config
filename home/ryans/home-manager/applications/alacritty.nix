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
        (builtins.fromTOML (builtins.readFile ../../../../themes/alacritty/rose-pine.toml))
        (lib.mkIf pkgs.stdenv.isDarwin {
          window.blur = true;
          window.opacity = 0.8;
        })
        {
          window = {
            dynamic_padding = true;
            padding = {
              x = 5;
              y = 5;
            };
          };

          env.TERM = "xterm-256color";

          scrolling = {
            history = 10000;
            multiplier = 3;
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
              family = "FantasqueSansM Nerd Font Mono";
              style = "Regular";
            };

            bold = {
              family = "FantasqueSansM Nerd Font Mono";
              style = "Bold";
            };

            italic = {
              family = "FantasqueSansM Nerd Font Mono";
              style = "Italic";
            };

            bold_italic = {
              family = "FantasqueSansM Nerd Font Mono";
              style = "Bold Italic";
            };
          };

          terminal = {
            shell = "${pkgs.fish}/bin/fish";
          };
        }
      ];
    };

    home.packages = [pkgs.nerd-fonts.fantasque-sans-mono];
  }
