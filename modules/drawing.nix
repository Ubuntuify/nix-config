{
  pkgs,
  lib,
  options,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
  with lib;
    mkMerge [
      (mkIf isLinux (
        if (builtins.hasAttr "hardware" options) # Hides from Nix that this block exists, as otherwise it will fail when building nix-darwin systems;
        then {
          home-manager.sharedModules = [{home.packages = with pkgs; [krita];}];

          hardware.opentabletdriver.enable = true;
        }
        else {}
      ))
      (mkIf isDarwin (
        if (builtins.hasAttr "homebrew" options) # Same reason, but vice versa; These should always evaluate to true, anyways.
        then {
          # Krita and OpenTabletDriver do not exist as nixpkgs (as they are marked as broken)
          # on MacOS, and such, we have to use homebrew to substitute them.

          homebrew = {
            casks = [
              "wacom-tablet"
              "krita"
            ];
          };
        }
        else {}
      ))
    ]
