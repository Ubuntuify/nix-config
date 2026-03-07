{
  pkgs,
  inputs,
  config,
  ...
}: let
  cfg = config.custom;
in {
  imports = [inputs.walker.homeManagerModules.default];

  programs.walker.enable = builtins.all (s: s) [
    pkgs.stdenv.hostPlatform.isLinux
    cfg.machine.graphics
    (cfg.linux.windowManager != null)
  ];
}
