{
  self,
  inputs,
  outputs,
  ...
}: let
  helpers = import ./helpers.nix {inherit self inputs outputs;};
in {
  inherit (helpers) mkDarwin mkHome mkNixos mkDroid forEachSupportedSystem;
}
