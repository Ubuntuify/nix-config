{
  pkgs,
  lib,
  config,
  ...
}: let
  isLinux = pkgs.stdenv.isLinux;
  isGraphical = config.hm-options.system.graphical;
in
  lib.mkIf (isLinux && isGraphical) {
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

    services.swayidle = {
      enable = true;
      events = [
        {
          event = "after-resume";
          command = "${config.wayland.windowManager.sway.package}/bin/swaymsg \"output * dpms on\"";
        }
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock";
        }
      ];
      timeouts = [
        {
          timeout = 300; # five minutes
          command = "${pkgs.swaylock}/bin/swaylock";
        }
        {
          timeout = 600; # ten minutes
          command = "${config.wayland.windowManager.sway.package}/bin/swaymsg \"output * dpms off\"";
          resumeCommand = "${config.wayland.windowManager.sway.package}/bin/swaymsg \"output * dpms on\"";
        }
      ];
    };
  }
