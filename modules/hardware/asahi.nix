{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; let
    reboot-macos = pkgs.writeShellScriptBin "reboot-macos" ''
      ${lib.getExe pkgs.asahi-bless} --set-boot-macos --yes
      echo "Rebooting to MacOS in five seconds..."
      sleep 5 && systemctl reboot
    '';
  in [asahi-bless reboot-macos];

  hardware.asahi.enable = true;

  # You can't touch EFI variables on an Asahi Linux system, and doing so will cause the switch to fail.
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
}
