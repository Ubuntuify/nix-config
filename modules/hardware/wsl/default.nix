{outputs, ...}: let
  internal = import ./__internal__.nix;
in {
  imports = [
    internal # required library
    outputs.lib.modules.hardware.wsl.wslg
  ];
}
