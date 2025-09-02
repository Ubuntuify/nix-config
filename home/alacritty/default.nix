{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty-graphics; # use a fork with sixel support (display images)
    settings = import ./alacritty-config.nix {inherit pkgs;};
  };
}
