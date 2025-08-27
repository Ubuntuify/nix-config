{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ryans";
  home.homeDirectory = "/home/ryans";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.swayfx
    pkgs.walker
    pkgs.autotiling-rs
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "${config.home.homeDirectory}/.config/sway" = {
      source = ./dotfiles/sway;
      recursive = true;
    };
    "${config.home.homeDirectory}/.config/waybar" = {
      source = ./dotfiles/waybar;
      recursive = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    userEmail = "ryanconrad2007@gmail.com";
    userName = "Ryan Salazar";
  };

  programs.fish = {
    enable = true;
  };

  programs.bash = {
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.alacritty = {
    enable = true;
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
          cursor ="#665c54";
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
    };
  };

  programs.lf = {
    enable = true;
  };

  programs.fastfetch = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
