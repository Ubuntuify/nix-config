{
  imports = [
    ./applications/alacritty.nix
    ./applications/firefox.nix
    ./shell/fish.nix
    ./shell/git.nix
    ./shell/lf.nix
    ./shell/neovim.nix
    ./shell/utilities.nix
    ./window-manager/sway.nix
    ./window-manager/waybar.nix
  ];

  xdg.enable = true;

  home.stateVersion = "25.11";
}
