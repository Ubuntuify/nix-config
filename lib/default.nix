{
  self,
  inputs,
  outputs,
  ...
}: {
  # Loads internal modules to be accessible top-level. Should not be used outside of
  # functions that are contained within this folder.
  __internal__ = import ./__internal__ {inherit self inputs outputs;};

  sysconfig = import ./sysconfig.nix {inherit self inputs outputs;};
  home = import ./home.nix {inherit self inputs outputs;};
  forEachSupportedSystem = let
    supportedSystems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];
  in
    f:
      inputs.nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import inputs.nixpkgs {inherit system;};
        });

  unsafeIf = bool: value:
    if bool
    then value
    else {}; # this should only be used to get away from errors (hack)
}
