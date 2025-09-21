{username, ...} @ args: {
  imports = [
    ../../common/hardware/nvidia.nix
  ];

  wsl = {
    enable = true;
    useWindowsDriver = true;
    startMenuLaunchers = true;
    docker-desktop = true;
  };

  wsl.defaultUser = username;

  home-manager.users.${username} = args.mkHome {config-name = username;};
  programs.command-not-found.enable = true;

  # workaround https://github.com/nix-community/NixOS-WSL/issues/454
  environment.sessionVariables.LD_LIBRARY_PATH = ["/run/opengl-driver/lib/"];
  environment.sessionVariables.GALLIUM_DRIVER = "d3d12";
}
