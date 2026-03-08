{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote # make sure that the lanzaboote module is loaded;
  ];

  environment.systemPackages = [pkgs.sbctl];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
