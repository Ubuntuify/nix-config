{
  config,
  lib,
  pkgs,
  ...
}: {
  wsl.enable = true;
  wsl.useWindowsDriver = true;
  wsl.docker-desktop.enable = true;
  wsl.startMenuLaunchers = true;

  wsl.defaultUser = "ryans";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  networking.hostName = "Andromeda";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
