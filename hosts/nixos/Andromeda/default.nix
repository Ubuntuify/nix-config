{
  systemUser,
  outputs,
  libx,
  ...
}: let
  inherit (outputs) modules;
in {
  imports = [
    modules.hardware.nvidia
  ];

  wsl = {
    enable = true;
    defaultUser = systemUser; # we no longer have to setup the user here, NixOS-WSL already does the rest
    useWindowsDriver = true;
    startMenuLaunchers = true;
    docker-desktop.enable = true;
  };

  home-manager.users.${systemUser} = libx.mkHome {config-name = systemUser;};

  # workaround https://github.com/nix-community/NixOS-WSL/issues/454
  environment.sessionVariables.LD_LIBRARY_PATH = ["/run/opengl-driver/lib/"];
  environment.sessionVariables.GALLIUM_DRIVER = "d3d12";
}
