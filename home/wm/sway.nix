{
  pkgs,
  lib,
  ...
}: let
  isLinux = pkgs.stdenv.isLinux;
in
  lib.mkIf isLinux {
    home.packages = with pkgs; [
      walker
      autotiling-rs
      grim
      #sway-contrib.inactive-windows-transparency
      #sway-contrib.grimshot
    ];

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
      # Workaround #5379 in nix-community/home-manager specifically
      # with pkgs.swayfx
      checkConfig = false;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
    };

    xdg.configFile = {
      "sway" = {
        source = ../../dotfiles/sway;
        recursive = true;
      };
    };

    home.pointerCursor = let
      getFrom = url: hash: name: {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = 48;
        package = pkgs.runCommand "moveUp" {} ''
          mkdir -p $out/share/icons
          ln -s ${
            pkgs.fetchzip {
              url = url;
              hash = hash;
            }
          }/dist $out/share/icons/${name}
        '';
      };
    in
      getFrom "https://github.com/yeyushengfan258/Future-cursors/archive/refs/heads/master.zip"
      "sha512-bQIr08VFngPe+5bYOcFSsmkTEH5VyQISXw+pU7tNZDq9ipUeEhyEBkp2QEcZdGeWyuTYz/D0oshmKOHP2eEAvg=="
      "Future-cursors";

    programs.swaylock = {
      enable = true;
    };
  }
