{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    walker
    autotiling-rs
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false; # WORKAROUND: TODO: REMOVE WHEN FIXED UPSTREAM
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

  home.pointerCursor =
    let
      getFrom = url: hash: name: {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = 48;
        package = pkgs.runCommand "moveUp" { } ''
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
