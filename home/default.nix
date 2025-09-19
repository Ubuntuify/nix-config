{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  isNixOS = builtins.hasAttr "nixosConfig" args;
  cfg = config.home-manager-options;
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

  options.home-manager-options = {
    user = mkOption {
      type = types.str;
      description = "User of this home-manager configuration";
    };
    system = {graphical = mkEnableOption "graphical home-manager modules";};
  };

  config = {
    home.username = cfg.user;
    home.homeDirectory = mkDefault (
      if pkgs.stdenv.isDarwin
      then "/Users/${cfg.user}"
      else "/home/${cfg.user}"
    ); # This needs to be set with mkDefault, as the nix-darwin module of home-manager
    # will throw an error otherwise if this is set.

    # This option does not exist on darwin systems, therefore should not be set if the
    # host system is not Linux.
    targets.genericLinux.enable = mkIf (pkgs.stdenv.isLinux) (!isNixOS);

    programs.home-manager.enable = true;

    xdg.enable = true;

    home.stateVersion = "25.11";
  };
}
