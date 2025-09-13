{
  lib,
  pkgs,
  ...
}: let
  defaultUser = "ryans";
in {
  wsl.enable = true;
  wsl.useWindowsDriver = true;
  wsl.docker-desktop.enable = true;
  wsl.startMenuLaunchers = true;

  wsl.defaultUser = defaultUser;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.${defaultUser} = lib.mkMerge [
    {
      hm-options.user = defaultUser;
      hm-options.isGraphical = false;
    }
    ../../home/default.nix
  ];

  networking.hostName = "Andromeda";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
