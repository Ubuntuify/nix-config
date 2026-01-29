{
  inputs,
  config,
  ...
}: {
  imports = [inputs.nixos-wsl.nixosModules.default];

  wsl.enable = true;
  wsl.defaultUser = config.custom.systemUser;
}
