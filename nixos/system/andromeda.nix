{
  lib,
  pkgs,
  mkHomeModules,
  ...
}: let
  defaultUser = "ryans";
in {
  imports = [
    ../common/nix-optimize-gc.nix
    ../wsl/gpu-accel.nix
    ../wsl/nvidia.nix
  ];

  wsl.enable = true;
  wsl.useWindowsDriver = true;
  wsl.docker-desktop.enable = true;
  wsl.startMenuLaunchers = true;

  wsl.defaultUser = defaultUser;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.${defaultUser} =
    lib.mkMerge (mkHomeModules {user = defaultUser;});

  networking.hostName = "Andromeda";

  environment.systemPackages = [pkgs.aria2 pkgs.wget];

  nixpkgs.config.allowUnfree = true;
  programs.command-not-found.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
