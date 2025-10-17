{
  self,
  inputs,
  outputs,
  ...
}: let
  importLibrary = module: import module {inherit self inputs outputs;};

  internal = importLibrary ./internal/default.nix;
in {
  # Top-level functions (frequently used functions - or common enough that they get brought out)
  inherit internal;
  inherit (outputs.lib.system) forEachSupportedSystem;

  # Functions that are used to mess with systems (like creating system modules, creating system configurations
  # and other related activities.)
  #
  # Often rely on the internal library, so if you are making changes there, check on the implementations located
  # in ./system.nix and ./system-modules.nix
  system = {
    inherit (importLibrary ./system.nix) forEachSupportedSystem mkNixos mkDarwin mkHomeEntry mkTopLevelHomeCfg;
    inherit (importLibrary ./system-modules.nix) mkMultiSystemModule mkDarwinModule mkNixosModule;

    darwin = importLibrary ./system/darwin.nix;
    nixos = importLibrary ./system/nixos.nix;
  };

  # Modules used by system configurations (also known as: NixOS or nix-darwin modules, though not all of them are
  # system-agnostic). It's automatically loaded through haumae.
  #
  # Check its documentation at: https://nix-community.github.io/haumea/
  modules = inputs.haumae.lib.load {
    src = ../modules;
    loader = inputs.haumae.lib.loaders.verbatim; # modules should be imported as-is, so they will have specialArgs, etc.
  };
}
