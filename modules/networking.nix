{
  networking.wireless.iwd = {
    enable = true;
    settings.general = {
      EnableNetworkConfiguration = true;
      AddressRandomization = true;
      AddressRandomizationRange = "full";
    };
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
}
