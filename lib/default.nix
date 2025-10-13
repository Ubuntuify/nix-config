{
  self,
  inputs,
  outputs,
  ...
}: {
  # Bring out some functions to be toplevel, for easier access. I.e. forEachSupportedSystem;
  inherit (outputs.lib.helpers) forEachSupportedSystem;
  inherit (import ./modules.nix {inherit self inputs outputs;}) mkMultiSystemModule mkNixosModule mkDarwinModule;

  # Make all helper functions available through outputs.lib.helpers.
  helpers = import ./helpers.nix {inherit self inputs outputs;};

  # Load in NixOS and Darwin modules through haumae (which works like a traditional scripting system, like Python.)
  modules = inputs.haumae.lib.load {
    src = ../modules;
    loader = inputs.haumae.lib.loaders.verbatim; # modules should be imported as-is, so they will have specialArgs, etc.
  };
}
