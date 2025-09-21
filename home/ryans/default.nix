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
      # user automatically generates the username and home directory according
      # to the defaults of the OS, such as /home/${user} for Linux and /Users/${user}
      # on Darwin/MacOS
      type = types.str;
      description = "User of this home-manager configuration";
    };
    system = {
      # Configuration for whether the user is TTY only (terminal/CLI applications are
      # the only ones that should be built) or has a graphical user interface, such as
      # a user-facing system.
      graphical = mkEnableOption "graphical home-manager modules";
    };
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
    # NixOS setups should setup using the included home-manager NixOS module, so
    # detecting the config attribute passed over should work well enough.

    programs.home-manager.enable = true;

    xdg.enable = true;

    home.stateVersion = "25.11";
  };
}
