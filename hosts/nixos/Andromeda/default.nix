{
  config,
  modules,
  outputs,
  ...
}: let
  inherit (outputs) overlays;
in {
  imports = [
    modules.hardware.nvidia
    modules.hardware.wsl.default
  ];

  nixpkgs.overlays = [
    overlays.lix
  ];

  home-manager.users.${config.custom.systemUser} = outputs.lib.system.mkHomeEntry {
    user = config.custom.systemUser;
    options = {machine.graphics = false;};
  };
}
