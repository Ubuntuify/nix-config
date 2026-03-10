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
        hashedPasswordFile = lib.mkIf (!config.users.mutableUsers) config.sops.secrets.users."passwords/ryans".path;
        extraGroups = ["wheel"];

        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../../secrets/keys/ryans/id_ed25519.pub)
        ];
      };

      home-manager.users.ryans = outputs.lib.home-manager.mkHomeEntry {
        user = "ryans";
        options = {linux.windowManager = "niri";}; # Fix later
      };
    }

    # sops-nix security plugin
    (lib.mkIf (builtins.hasAttr "sops" config) {
      sops.secrets = {
        "passwords/ryans".neededForUsers = true;
      };
    })
  ]
