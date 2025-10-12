{inputs}: final: prev: let
  inherit (inputs) nixpkgs;
  pkgs = import nixpkgs {inherit (prev) system;};
in
  # Usually running on the main branch comes with consequences, but - if you trust Lix's developers, they have a
  # policy for keeping main workable.
  #
  # For now, this is kept this way to have the experimental feature "flake-self-attrs", which this flake uses to
  # enable submodule support.
  with pkgs.lixPackageSets.git; {
    nix = lix; # replaces nix with lix
    inherit nixpkgs-review nix-eval-jobs nix-fast-build colmena; # replaces all other utilities with lix alternatives
  }
