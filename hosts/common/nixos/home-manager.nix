# No NixOS-specific configuration is needed at this time, so simply
# pass in the home-manager NixOS module.
{inputs, ...}: {
  imports = [inputs.home-manager.nixosModules.default];
}
