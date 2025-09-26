{...}: {
  networking.wireless.iwd = {
    enable = true;
    settings.general.EnableNetworkConfiguration = true;
  };

  boot = {
    supportedFilesystems = ["ntfs" "btrfs"];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = false;
    };
  };

  users.mutableUsers = false;
}
