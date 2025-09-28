{pkgs, ...}: {
  terminal.font = let
    fontDirectory = "fonts/truetype";
  in "${pkgs.nerd-fonts.iosevka-term-slab}/share/${fontDirectory}/NerdFonts/IosevkaTermSlab/IosevkaTermSlabNerdFont-Medium.ttf";

  # Enable some Termux (Nix on Droid) features for compatibility.
  android-integration.am.enable = true;
  android-integration.termux-open.enable = true;
  android-integration.termux-open-url.enable = true;
  android-integration.termux-reload-settings.enable = true;
  android-integration.xdg-open.enable = true;

  environment.packages = let
    nix-elevation-stub = pkgs.writeShellScriptBin "sudo" ''
      # This is a stub which attempts to handle root escalations from binaries/apps in the nix store.
      # Android is *not* a standard setting, and may cause damage and even bricking if simply allowed.
      set -eu
      set -o pipefail

      function printDisclaimer() {
        echo "If you are reading this message, this means a utility (or you) attempted to elevate through sudo, which is not possible on Nix on Droid. This may lead to some unexpected behavior, please do not report to bug trackers if something goes wrong regarding permissions, and refer to the Nix On Droid bugtracker if applicable."
      }

      function execAsStub() {
        printDisclaimer
        exec $@
      }

      case $1 in
        -e|--elevate)
          # Check for root presence before attempting to elevate.
          if [ -f /system/bin/magisk ]; then
            echo "Found Magisk binary, elevating command through it."
            exec /system/bin/magisk su $@
          fi

          # No root detected.
          echo "Root was not detected, cannot elevate."
          exit 127
          ;;
        *)
          execAsStub
          ;;
      esac
    '';
  in
    with pkgs; [
      # These packages are taken from nixpkgs.
      nh
      aria2
      dua
      duf
      wget2
      nix-tree
      uv

      # Custom packages for compatibility.
      nix-elevation-stub
    ];

  system.stateVersion = "24.05";
}
