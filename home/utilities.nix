{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config.theme = "Nord";
  };

  programs.cava = {
    enable = true;
    settings = {
      color = {
        background = "'#232136'";
        gradient = 1;
        gradient_count = 6;
        gradient_color_1 = "'#3e8fb0'";
        gradient_color_2 = "'#9ccfd8'";
        gradient_color_3 = "'#c4a7e7'";
        gradient_color_4 = "'#ea9a97'";
        gradient_color_5 = "'#f6c177'";
        gradient_color_6 = "'#eb6f92'";
      };
    };
  };

  programs.fastfetch.enable = true;

  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [".git/" "*.bak" ".DS_Store"];
  };

  home.packages = with pkgs; [
    zip
    xz
    unzip
    _7zz
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    btop
    lsof
    ethtool
    lm_sensors
    pciutils
    usbutils
  ];
}
