{
  outputs,
  systemUser,
  ...
}: let
  inherit (outputs) overlays;
  inherit (outputs.lib) modules;
in {
  imports = [
    ./hardware-configuration.nix
    modules.hardware.asahi
    modules.kmscon
    modules.audio
    modules.drawing
    modules.fonts
    modules.networking
    modules.window-manager
    modules.display-manager.ly
  ];

  # Custom settings for modules.hardware.asahi.
  custom.asahi = {
    firmwareHash = "sha256-9XuPmUICc+MBtRRX3SlIrLE1zspkR+OSaAtd0s6sWH4=";
    hasTouchBar = true;
  };

  nixpkgs.overlays = [
    overlays.lix
  ];

  services.xserver = {
    enable = true;
  };

  security.polkit.enable = true;

  boot = {
    supportedFilesystems = ["btrfs"];
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
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
