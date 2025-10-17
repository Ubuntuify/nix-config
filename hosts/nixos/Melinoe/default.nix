{
  outputs,
  config,
  ...
}: let
  inherit (outputs) overlays;
  inherit (outputs.lib) modules;
in {
  imports = [
    ./hardware-configuration.nix
    modules.hardware.asahi
    modules.security.sops
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
      configurationLimit = 3;
    };
    kernelParams = ["zswap.enabled=1" "zswap.compressor=zstd" "zswap.zpool=zsmalloc" "zswap.max_pool_percent=50"];
  };

  home-manager.users.${config.custom.systemUser} = outputs.lib.system.mkHomeEntry {
    user = config.custom.systemUser;
    options = {machine.graphics = true;};
  };

  users.mutableUsers = true;

  system.stateVersion = "25.11";
}
