{inputs}: final: prev: let
  inherit (inputs) nixpkgs;
  pkgs = import nixpkgs {inherit (prev) system;};
in
  with pkgs.lixPackageSets.latest; {
    nix = lix; # replaces nix with lix
    inherit nixpkgs-review nix-eval-jobs nix-fast-build colmena; # replaces all other utilities with lix alternatives
  }
