{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf (
  builtins.all (s: s) [
    pkgs.stdenv.hostPlatform.isLinux
    config.custom.machine.graphics
  ]
) {
  home.packages = with pkgs; [
    mpvpaper
    nemo
  ];

  # Link in config.kdl (until an upstream module is made for home-manager)
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink ./config.kdl;
}
