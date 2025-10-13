{
  wsl.useWindowsDriver = true;
  wsl.startMenuLaunchers = true;

  # Workaround https://github.com/nix-community/NixOS-WSL/issues/454
  environment.sessionVariables.LD_LIBRARY_PATH = [
    "/run/opengl-driver/lib/"
  ];
  environment.sessionVariables.GALLIUM_DRIVER = "d3d12";
}
