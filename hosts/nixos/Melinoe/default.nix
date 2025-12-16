{
  outputs,
  config,
  ...
}: let
  inherit (outputs) overlays;
  inherit (outputs.lib) modules;
in {
  imports = [
    ./generated/hardware-configuration.nix
    ./system-specific/bootloader.nix
    ./system-specific/miscellaneous.nix
    ./system-specific/swap.nix
    modules.hardware.asahi
    modules.security.sops
    modules.audio
    modules.drawing
    modules.fonts
    modules.networking
    modules.window-manager
    modules.display-manager.ly
  ];

  # Options required for Asahi (apple-silicon)'s hardware module, such as providing the firmware hash
  # for pure flakes, and other options like touch bar support.
  custom.asahi = {
    firmwareHash = "sha256-9XuPmUICc+MBtRRX3SlIrLE1zspkR+OSaAtd0s6sWH4=";
    hasTouchBar = true;
  };

  nixpkgs.overlays = [
    overlays.lix
  ];

  services.xserver.enable = true;
  security.polkit.enable = true;

  home-manager.users.${config.custom.systemUser} = outputs.lib.system.mkHomeEntry {
    user = config.custom.systemUser;
    options = {machine.graphics = true;};
  };

  users.mutableUsers = true;

  system.stateVersion = "25.11";
}
