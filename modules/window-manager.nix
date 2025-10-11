{
  config,
  lib,
  ...
}:
with lib; let
  configList = builtins.attrValues config.home-manager.users;
  makeWindowManagerConfig = windowManager: let
    definedPackages = builtins.catAttrs "wayland.windowManager.${windowManager}.package" configList;
  in {
    programs.${windowManager} = {
      # Checks if any user on the system has the window manager enabled in home-manager.
      enable = builtins.any (cfg: cfg.wayland.windowManager.${windowManager}.enable) configList;

      # We only get to choose one package for a window manager, so we'll have to compromise and pick the
      # first one.
      package = mkIf (lists.length definedPackages != 0) (builtins.elemAt definedPackages 0);
    };
  };
in
  mkMerge [
    # Do a check if home-manager configures a specific window manager, and if so, enable the appropriate NixOS feature
    (makeWindowManagerConfig "sway")
    (makeWindowManagerConfig "hyprland")
    {
      environment.sessionVariables.NIXOS_OZONE_WL = 1; # enable wayland support for electron/chromium based apps.
    }
  ]
