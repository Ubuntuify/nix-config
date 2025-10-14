{
  inputs,
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
    sops = lib.mkIf config.custom.security.sops.enable {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      validateSopsFiles = true;

      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true; # auto generates a key
      };
    };
  };
}
