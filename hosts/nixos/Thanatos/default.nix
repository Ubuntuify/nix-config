{...}: {
  networking.wireless.iwd = {
    enable = true;
    settings.general.EnableNetworkConfiguration = true;
  };

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
}
