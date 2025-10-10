{
  systemUser,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home-manager.users.${systemUser};
in
  # Do a dumb check if home-manager configures a specific window manager, and if so, enable the appropriate NixOS feature
  mkMerge [
    (mkIf cfg.wayland.windowManager.sway.enable {
      # TODO: make this code better.
      # This won't work on multi-user systems.
      programs.sway.enable = true;
      programs.sway.package = cfg.wayland.windowManager.sway.package;
    })
  ]
