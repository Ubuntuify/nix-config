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
    ./fish.nix
    ./git.nix
    ./lf.nix
    ./neovim.nix
    ./utilities.nix
    ./graphical/alacritty.nix
    ./graphical/sway.nix
    ./graphical/waybar.nix
    ./graphical/firefox.nix
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

    xdg.enable = true;

    home.stateVersion = "25.11";
  };
}
