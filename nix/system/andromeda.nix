{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [<nixos-wsl/modules>];

  wsl = {
    enable = true;
    useWindowsDriver = true;
    docker-desktop.enable = true;
    startMenuLaunchers = true;
    defaultUser = "ryans";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.ryans = lib.mkMerge [
    ../../home.nix
    ../../home/common.nix
  ];

  networking.hostName = "Andromeda";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
