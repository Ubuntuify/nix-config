{...}: final: prev:
# Usually running on the main branch comes with consequences, but - if you trust Lix's developers, they have a
# policy for keeping main workable.
#
# For now, this is kept this way to have the experimental feature "flake-self-attrs", which this flake uses to
# enable submodule support.
{
  nix = prev.lixPackageSets.git.lix; # replaces nix with lix
  inherit (prev.lixPackageSets.git) nixpkgs-review nix-eval-jobs nix-fast-build colmena; # replaces all other utilities with lix alternatives
}
