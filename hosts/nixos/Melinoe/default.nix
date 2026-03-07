{
  outputs,
  modules,
  config,
  ...
}: let
  inherit (outputs) overlays;
in {
  imports = [
    ./generated/hardware-configuration.nix
    ./system-specific/bootloader.nix
    ./system-specific/swap.nix
    modules.hardware.asahi
    modules.security.sops
    modules.audio
    modules.drawing
    modules.fonts
    modules.networking
    modules.window-manager
    modules.printing
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

  home-manager.users.${config.custom.systemUser} = outputs.lib.home.mkHomeEntry {
    user = config.custom.systemUser;
    options = {machine.graphics = true;};
  };

  programs.niri.enable = true;

  users.mutableUsers = true;

  system.stateVersion = "25.11";
}
