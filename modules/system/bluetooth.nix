{lib, ...}: {
  hardware.bluetooth.enable = true;

  services.blueman.enable = lib.mkDefault true;
}
