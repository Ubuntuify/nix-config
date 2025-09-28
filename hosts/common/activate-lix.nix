{pkgs, ...}:
# Lix is an alternative (fork) implementation of Nix, which claims to be more
# performant than its competitor, CppNix (standard Nix)
{
  nix.package = pkgs.lixPackageSets.latest.lix;

  nixpkgs.overlays = [
    (final: prev: {
      inherit
        (prev.lixPackageSets.latest)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];
}
