{
  lib,
  pkgs,
  inputs,
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

  home-manager.users.${defaultUser} = lib.mkMerge [
    {
      hm-options.user = defaultUser;
      hm-options.isGraphical = false;
    }
    ../../home/default.nix
    inputs.nvf.homeManagerModules.default
  ];

  networking.hostName = "Andromeda";

  environment.systemPackages = [pkgs.aria2 pkgs.wget];

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
