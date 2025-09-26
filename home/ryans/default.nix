{lib, ...} @ args: {
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
    system = {
      # Configuration for whether the user is TTY only (terminal/CLI applications are
      # the only ones that should be built) or has a graphical user interface, such as
      # a user-facing system.
      graphical = lib.mkEnableOption "graphical home-manager modules";
      isLowRam = lib.mkEnableOption "to enable Low RAM optimizations (4-8GiB)";
    };
  };

  config = {
    xdg.enable = true;
    home.stateVersion = "25.11";
  };
}
