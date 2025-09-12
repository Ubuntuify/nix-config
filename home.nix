{pkgs, ...} @ args: let
  isNixOS = builtins.hasAttr "nixosConfig" args;
in {
  home.username = "ryans";
  home.homeDirectory = "/home/ryans";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
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

  home.sessionVariables = {
    EDITOR = "nvim";
    GROFF_NO_SGR = 1;
  };

  targets.genericLinux.enable = !isNixOS;
  programs.home-manager.enable = true;
}
