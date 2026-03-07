{
  outputs,
  config,
  lib,
  ...
}: let
in
  lib.mkMerge [
    {
      users.users.ryans = {
        isNormalUser = true;
        hashedPasswordFile = lib.mkIf (!config.users.mutableUsers) config.sops.secrets.users.ryans.path;
        extraGroups = ["wheel" "pipewire"];
      };

      home-manager.users.ryans = outputs.lib.home-manager.mkHomeEntry {
        user = "ryans";
        options = {linux.windowManager = "niri";}; # Fix later
      };
    }

    # sops-nix security plugin
    (lib.mkIf (builtins.hasAttr "sops" config) {
      sops.secrets = {
        ryans.neededForUsers = true;
      };
    })
  ]
