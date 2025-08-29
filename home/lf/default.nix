{ pkgs, config, ... }:

{
  programs.lf = {
    enable = true;

    extraConfig = ''
      set icons
    '';

    previewer = {
      source = pkgs.writeShellScript "pv.sh" ''
        #!/usr/bin/env bash

        MIME=$(file --mime-type -b "$1")
        #echo "$MIME"

        case "$MIME" in
          # .pdf
          *application/pdf*)
            pdftotext "$1" -
            ;;
          # .7z
          *application/x-7z-compressed*)
            7zz l "$1"
            ;;
          # .tar .tar.Z
          *application/x-tar*)
            tar -tvf "$1"
            ;;
          # .tar.*
          *application/x-compressed-tar*|*application/x-*-compressed-tar*)
            tar -tvf "$1"
            ;;
          # .rar
          *application/vnd.rar*)
            unrar l "$1"
            ;;
          # .zip
          *application/zip*)
            unzip -l "$1"
            ;;
          # any plain text file that doesn't have a specific handler
          *text/plain*)
          # return false to always repaint, in case terminal size changes
          bat --force-colorization --paging=never --style=changes,numbers \
            --terminal-width $(($2 - 3)) "$1" && false
          ;;
          *)
            echo "unknown format"
          ;;
        esac
      '';
    };

    keybindings = {
      "<f-2>" = "rename";
      "a" = ":push %mkdir<space>";
      "t" = ":push %touch<space>";
    };
  };

  # Adds required syntax highlighting
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  xdg.configFile = {
    "lf/icons".source = ./icons;
    "lf/colors".source = ./colors;
  };

  programs.fish.functions = {
    lfcd = {
      wraps = "lf";
      description = "lf - Terminal file manager (changing directory on exit)";
      body = "cd \"$(command lf -print-last-dir $argv)\"";
    };
  };
}
