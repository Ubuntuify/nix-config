{pkgs, ... }:
{
  programs.nvf = {
    enable = true;
    settings = import ./nvf-config.nix;
  };

  home.packages = [ pkgs.ueberzugpp ];
}
