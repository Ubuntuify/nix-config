{
  self,
  inputs,
  outputs,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit self inputs outputs;};
  home-manager.backupFileExtension = "bak";
}
