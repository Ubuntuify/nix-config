# Kept for backwards compatibility, and is a naive approach
# to importing home-manager plugins.
#
# If you are specifying a specific machine's home-manager
# config, always default to specifying the modules directly.
{
  config,
  lib,
  ...
} @ args:
with lib; let
  isNixOS = builtins.hasAttr "nixosConfig" args;
  cfg = config.hm-options;
in {
  imports = [
    ./alacritty/default.nix
    ./firefox/default.nix
    ./fish/default.nix
    ./git/default.nix
    ./lf/default.nix
    ./neovim/default.nix
    ./wm/sway.nix
    ./wm/waybar.nix
    ./utilities.nix
  ];

  options.hm-options = {
    user = mkOption {
      type = types.str;
      description = "User of this home-manager configuration";
    };
    isGraphical = mkEnableOption "graphical home-manager modules";
  };

  config = {
    home.username = cfg.user;
    home.homeDirectory = "/home/${cfg.user}";

    targets.genericLinux.enable = !isNixOS;
    programs.home-manager.enable = true;

    home.stateVersion = "25.11";
  };
}
