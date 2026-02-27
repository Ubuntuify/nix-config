{
  config,
  modules,
  outputs,
  ...
}: let
  inherit (outputs) overlays;
in {
  imports = [
    modules.hardware.wsl.nvidia
  ];

  nixpkgs.overlays = [
    overlays.lix
  ];

  home-manager.users.${config.custom.systemUser} = outputs.lib.home.mkHomeEntry {
    user = config.custom.systemUser;
    options = {machine.graphics = false;};
  };
}
