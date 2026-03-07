{
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
  home.packages = with pkgs; [
    mpvpaper
    nemo
    xwayland-satellite
  ];

  # Link in config.kdl (until an upstream module is made for home-manager)
  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
