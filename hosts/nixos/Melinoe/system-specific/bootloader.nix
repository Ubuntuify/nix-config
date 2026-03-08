{pkgs, ...}: {
  boot = {
    supportedFilesystems = ["btrfs"];

    loader.grub = {
      enable = true;
      configurationLimit = 5;
      font = "${pkgs.iosevka}/share/fonts/truetype/Iosevka-Medium.ttf";
      fontSize = 32;
    };
  };
}
