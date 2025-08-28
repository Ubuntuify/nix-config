{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ryans";
  home.homeDirectory = "/home/ryans";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    swayfx
    walker
    autotiling-rs
    nemo

    # archive format / programs
    zip
    xz
    unzip
    _7zz

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    onefetch

    # utilities
    btop
    lsof

    # system tools
    ethtool
    lm_sensors
    pciutils
    usbutils
  ];

  imports = [
    ./home
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "${config.home.homeDirectory}/.config/sway" = {
      source = ./dotfiles/sway;
      recursive = true;
    };
    "${config.home.homeDirectory}/.config/waybar" = {
      source = ./dotfiles/waybar;
      recursive = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.lf = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
