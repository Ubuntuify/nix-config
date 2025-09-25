{
  pkgs,
  lib,
  ...
}: {
  # To properly setup secure boot, NixOS/lanzaboote requires manual setup on your system.
  # Please refer to https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md

  environment.systemPackages = with pkgs; [sbctl]; # For diagnosing issues with secure boot.

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = ["/var/lib/sbctl"];
  };
}
