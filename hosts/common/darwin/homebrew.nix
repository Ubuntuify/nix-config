{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew # makes sure homebrew config is available;
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = lib.mkDefault true;
    autoMigrate = lib.mkForce true; # we shouldn't be nuking previous homebrew installs non-discriminately.
    user = config.system.primaryUser or config.custom.systemUser;
  };

  homebrew = {
    enable = true;
    user = config.nix-homebrew.user;
    onActivation.cleanup = lib.mkDefault "zap"; # careful! this removes all non-declared homebrew packages.
  };
}
