{pkgs, ...}: {
  imports = [
    ./alacritty/default.nix
    ./fastfetch/default.nix
    ./fish/default.nix
    ./git/default.nix
    ./lf/default.nix
    ./neovim/default.nix
    ./utilities/default.nix
    ./wm/default.nix
  ];
}
