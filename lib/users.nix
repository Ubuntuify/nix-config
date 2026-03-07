{
  inputs,
  outputs,
  ...
}: {
  getNixUserModule = user: ../home/${user}/nixos/default.nix;
}
