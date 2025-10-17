{outputs, ...}: {
  mkUserModules = users: outputs.lib.internal.getUserCfgs users ../../home "nixos";
}
