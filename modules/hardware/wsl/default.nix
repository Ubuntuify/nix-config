# This is the main module for WSL support, all modules created under this directory should import
# this file.
{
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [inputs.nixos-wsl.nixosModules.default];

  options.custom = {
    wsl.graphics = lib.mkEnableOption "enable WSLg (hardware acceleration for GPU passthrough)";
  };

  config = lib.mkDefault {
    wsl.enable = true;
    wsl.defaultUser = cfg.systemUser;
    wsl.interop.includePath = true;
    wsl.interop.register = true;

    # use the default provided by the option
    wsl.useWindowsDriver = config.custom.wsl.graphics;
  };
}
