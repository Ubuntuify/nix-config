{
  boot = {
    supportedFilesystems = ["btrfs"];
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
  };
}
