{lib, ...}:
lib.mkMerge [
  # Checks if Lix is present, and enables the option required for what this flake requires
  # (submodule support) through inputs.self.submodules
  #
  # TODO: make it detect if the Lix overlay is active, instead of checking the current nix
  # version which may take it one generation to figure out it the overlays is active
  (
    lib.mkIf (builtins.all (x: x) [
      ((builtins.substring ((builtins.stringLength builtins.nixVersion) - 3) 3 builtins.nixVersion)
        == "lix")
    ]) {
      nix.settings.experimental-features = ["flake-self-attrs"];

      # Stop erroring out when an unexpected experimental feature pops up (from Lix, a hard fork of CppNix).
      nix.checkConfig = false;
    }
  )

  # Other miscelleanous additions.
]
