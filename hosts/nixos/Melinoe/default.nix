{
  outputs,
  systemUser,
  ...
}: let
  inherit (outputs) modules;
in {
  imports = [
    ./hardware-configuration.nix
    modules.hardware.asahi
    modules.audio
    modules.drawing
    modules.fonts
    modules.networking
    modules.window-manager
  ];

  # Custom settings for modules.hardware.asahi.
  custom.asahi = {
    firmwareHash = "sha256-9XuPmUICc+MBtRRX3SlIrLE1zspkR+OSaAtd0s6sWH4=";
    hasTouchBar = true;
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
    };
    kernelParams = ["zswap.enabled=1" "zswap.compressor=zstd" "zswap.zpool=zsmalloc" "zswap.max_pool_percent=50"];
  };

  users.users.${systemUser} = {
    isNormalUser = true;
    initialPassword = "nix-is-the-best";
    createHome = true;
    extraGroups = ["wheel"];
  };

  home-manager.users.${systemUser} = outputs.lib.mkHome {options.system.graphical = true;};

  users.mutableUsers = true;
}
