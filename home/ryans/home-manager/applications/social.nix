{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = lib.mkIf config.custom.system.graphics [
    pkgs.legcord
  ];
}
