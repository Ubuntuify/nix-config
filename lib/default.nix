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
  home-manager = import ./home-manager.nix {inherit self inputs outputs;};
  users = import ./users.nix {inherit self inputs outputs;};

  forEachSupportedSystem = let
    supportedSystems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];
  in
    f:
      inputs.nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import inputs.nixpkgs {inherit system;};
        });

  unsafeIf = bool: value:
    if bool # This disables validation from nix on whether whatever is inside is
    then value # valid. This should only be used if you know what you are doing, and
    else {}; # know the consequences. Also, disables lazy evaluation.
}
