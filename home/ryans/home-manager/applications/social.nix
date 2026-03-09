{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages =
    lib.mkIf (builtins.all (s: s) [
      pkgs.stdenv.hostPlatform.isLinux
      config.custom.system.graphics
    ]) [
      pkgs.legcord
    ];
}
