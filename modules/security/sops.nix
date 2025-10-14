{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.custom.security.sops = {
    enable = lib.mkOption {
      description = "Whether to enable sops-nix secrets management.";
      type = lib.types.bool;
      default = true;
    };
  };

  config = {
    services.openssh.enable = lib.mkDefault true; # OpenSSH is required
    # for converting keys into sops keys, so set this as default.

    sops = lib.mkIf config.custom.security.sops.enable {
      defaultSopsFile = ../../secrets/secrets.yaml;
      validateSopsFiles = true;

      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true; # auto generates a key
      };
    };

    # Add packages required for sops-nix secret keeping, so we don't have
    # to add it to the profile manually.
    environment.systemPackages = [pkgs.age pkgs.sops];
  };
}
