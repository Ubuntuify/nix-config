{
  imports = [
    ./applications/alacritty.nix
    ./applications/firefox.nix
    ./shell/fish.nix
    ./shell/git.nix
    ./shell/lf.nix
    ./shell/neovim.nix
    ./shell/utilities.nix
    ./utilities/walker.nix
    ./window-manager/sway
    ./window-manager/niri
  ];

  xdg.enable = true;

  home.stateVersion = "25.11";
}
