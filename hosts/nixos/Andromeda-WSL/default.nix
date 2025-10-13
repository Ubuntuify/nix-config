{
  config,
  outputs,
  ...
}: let
  inherit (outputs.lib) modules;
  inherit (outputs) overlays;
in {
  imports = [
    modules.hardware.nvidia
    modules.wsl.default
  ];

  nixpkgs.overlays = [
    overlays.lix
  ];

  home-manager.users.${config.custom.systemUser} = outputs.lib.mkHome {};
}
