{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom;
in
  lib.mkIf (builtins.all (self: self) [
    pkgs.stdenv.hostPlatform.isLinux
    cfg.machine.graphics
    (cfg.linux.window-manager != null)
  ]) {
    services.walker = {enable = true;};
  }
