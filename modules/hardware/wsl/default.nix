# This is the main module for WSL support, all modules created under this directory should import
# this file.
{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.custom;
in
  lib.mkMerge [
    {
      imports = [inputs.nixos-wsl.nixosModules.default];

      config = {
        wsl.enable = true;
        wsl.defaultUser = config.custom.systemUser;
      };

      options.custom = {
        wsl.graphics = lib.mkOption "enable WSLg (hardware acceleration for GPU passthrough)";
      };
    }
    (
      lib.mkIf cfg.wsl.graphics {
        wsl.useWindowsDriver = true;
        wsl.startMenuLaunchers = true;

        # Workaround https://github.com/nix-community/NixOS-WSL/issues/454
        environment.sessionVariables.LD_LIBRARY_PATH = [
          "/run/opengl-driver/lib/"
        ];
        environment.sessionVariables.GALLIUM_DRIVER = "d3d12";
      }
    )
  ]
