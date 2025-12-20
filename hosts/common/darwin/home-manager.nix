{inputs, ...}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager # make sure the home manager module is loaded
  ];
}
