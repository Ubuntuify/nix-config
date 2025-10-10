{inputs, ...}: let
  pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
in {
  # Flakes run in "pure" evaluation mode on nix, making them unable to simply require the <ESP>/asahi partition.
  # Therefore, to make the system reproducible, it has to have the hash of the peripheral firmware directory.
  #
  # This simplifies the creation of one and simply requires the hash, while also providing instructions when
  # errors happen.
  mkPeripheralFirmwareDirectory = hash:
    pkgs.requireFile {
      inherit hash;
      name = "asahi";
      hashMode = "recursive";
      message = ''
        Linux on Apple Silicon requires proprietary firmware blobs taken from MacOS to function correctly, run the below command on your system, and if it doesn't work, try the following troubleshooting steps.

        nix-store --add-fixed sha256 --recursive <path-to-asahi-esp>/asahi

        #1) Is the hash of your firmware directory different from the one listed here? Check with `nix hash --algo sha256 <path-to-asahi-esp>/asahi`
        #2) Is this your first install? Running this command on the installation environment won't work, and you'll have to first run without it and run it on the system itself before doing a switch.
      '';
    };
}
