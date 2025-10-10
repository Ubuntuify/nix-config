{
  pkgs,
  systemUser,
  libx,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = pkgs.requireFile {
      name = "asahi";
      hashMode = "recursive";
      hash = "sha256-9XuPmUICc+MBtRRX3SlIrLE1zspkR+OSaAtd0s6sWH4=";
      message = ''
        Asahi Linux requires proprietary firmware blobs from MacOS, and cannot fit with a pure evaluation of a flake, without it being illegal to post the repository online. Run the following command to continue past this error.

        nix-store --add-fixed sha256 --recursive <path-to-asahi-esp>/asahi
      '';
    };
  };

  networking.wireless.iwd = {
    enable = true;
    settings.general.EnableNetworkConfiguration = true;
  };
  networking.networkmanager.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.displayManager.ly = {
    enable = true;
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
    kernelParams = ["zswap.enabled=1" "zswap.compressor=zstd" "zswap.zpool=zsmalloc" "zswap.max_pool_percent=50"];
  };

  users.users.${systemUser} = {
    isNormalUser = true;
    initialPassword = "nix-is-the-best";
    createHome = true;
    extraGroups = ["wheel"];
  };

  home-manager.users.${systemUser} = libx.mkHome {options.system.graphical = true;};

  users.mutableUsers = true;
}
