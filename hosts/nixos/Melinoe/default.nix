{
  outputs,
  pkgs,
  systemUser,
  libx,
  ...
}: let
  inherit (outputs) modules;
in {
  imports = [
    ./hardware-configuration.nix
    modules.audio
    modules.drawing
    modules.fonts
    modules.networking
    modules.window-manager
  ];

  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = pkgs.requireFile {
      name = "asahi";
      hashMode = "recursive";
      hash = "sha256-9XuPmUICc+MBtRRX3SlIrLE1zspkR+OSaAtd0s6sWH4=";
      message = ''
        Linux on Apple Silicon requires proprietary firmware blobs taken from MacOS to function correctly, run the below command on your system, and if it doesn't work, try the following troubleshooting steps.

        nix-store --add-fixed sha256 --recursive <path-to-asahi-esp>/asahi

        #1) Is the hash of your firmware directory different from the one listed here? Check with `nix hash --algo sha256 <path-to-asahi-esp>/asahi`
        #2) Is this your first install? Running this command on the installation environment won't work, and you'll have to first run without it and run it on the system itself before doing a switch.
      '';
    };
  };

  services.xserver = {
    enable = true;
  };

  security.polkit.enable = true;

  services.displayManager.ly = {
    enable = true;
    x11Support = true;
  };

  systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";

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
