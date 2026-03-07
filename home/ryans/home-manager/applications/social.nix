{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = lib.mkIf config.custom.machine.graphics [
    pkgs.legcord
  ];
}
