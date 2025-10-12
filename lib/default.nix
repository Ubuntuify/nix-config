{
  self,
  inputs,
  outputs,
  ...
}: let
  helpers = import ./helpers.nix {inherit self inputs outputs;};
  moduleLib = import ./modules.nix {inherit self inputs outputs;};
in {
  inherit (helpers) mkDarwin mkHome mkNixos mkDroid forEachSupportedSystem;
  inherit (moduleLib) mkMultiSystemModule;

  modules = inputs.haumae.lib.load {
    src = ../modules;
    loader = inputs.haumae.lib.loaders.verbatim; # modules should be imported as-is, so they will have specialArgs, etc.
  };
}
