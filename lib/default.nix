{
  self,
  inputs,
  outputs,
  ...
}: let
  mkLib = module: import module {inherit self inputs outputs;};
in {
  # Top-level functions (frequently used functions - or common enough that they get brought out)
  __internal__ = mkLib ./__internal__;

  inherit (outputs.lib.system) forEachSupportedSystem;

  # Functions that are used to mess with systems (like creating system modules, creating system configurations
  # and other related activities.)
  #
  # Often rely on the internal library, so if you are making changes there, check on the implementations located
  # in ./system.nix and ./system-modules.nix
  system = {
    inherit (mkLib ./system.nix) forEachSupportedSystem mkNixos mkDarwin mkHomeEntry mkTopLevelHomeCfg;
    inherit (mkLib ./system-modules.nix) mkMultiSystemModule mkDarwinModule mkNixosModule;

    darwin = mkLib ./system/darwin.nix;
    nixos = mkLib ./system/nixos.nix;
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
