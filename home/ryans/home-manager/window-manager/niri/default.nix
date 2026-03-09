{
  inputs,
  pkgs,
  lib,
  config,
  nixosConfig,
  ...
}:
lib.mkIf (
  builtins.all (s: s) [
    pkgs.stdenv.hostPlatform.isLinux
    config.custom.system.graphics
    (config.custom.linux.windowManager == "niri")
  ]
) {
  home.packages = with pkgs; let
    nur = inputs.nur.legacyPackages.${stdenv.hostPlatform.system};
  in [
    nemo
    mpvpaper
    xwayland-satellite
    nur.repos.sagikazarmark.sf-pro
  ];

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = false;
        disable_loading_bar = false;
      };

      animations = {
        enabled = true;
        bezier = "linear, 1, 1, 0, 0";
      };
    };
    extraConfig = builtins.readFile ./hyprlock/hyprlock.conf;
  };

  # Link in config.kdl (until an upstream module is made for home-manager)
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  gtk = {
    enable = true;
    iconTheme = {
      name = "la-capitaine-icon-theme";
      package = pkgs.la-capitaine-icon-theme;
    };
    theme.name = "squared-gtk";
    theme.package = pkgs.callPackage ../../../../../pkgs/themes/squared-gtk.nix {};
  };
}
