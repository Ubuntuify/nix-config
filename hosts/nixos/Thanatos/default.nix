{systemUser, ...}: {
  hardware.asahi = {
    enable = true;
  };

  networking.wireless.iwd = {
    enable = true;
    settings.general.EnableNetworkConfiguration = true;
  };
  networking.networkmanager.enable = true;

  boot = {
    supportedFilesystems = ["ntfs" "btrfs"];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = false;
    };
    kernelParams = ["zswap.enabled=1" "zswap.compressor=zstd" "zswap.zpool=zsmalloc" "zswap.max_pool_percent=50"];
  };

  users.users.${systemUser} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  users.mutableUsers = false;
}
