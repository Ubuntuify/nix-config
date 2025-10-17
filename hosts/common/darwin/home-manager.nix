{inputs, ...}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager # make sure the home manager module is loaded
  ];

  home-manager.sharedModules = [
    # Makes sure that trampoline applications (as a workaround for Spotlight ignoring symlinks)
    # is enabled for all users using home-manager.
    inputs.mac-app-util.homeManagerModules.default

    # Disables home-manager's default symlink method, which is superseded by mac-app-util's
    # trampoline method.
    {targets.darwin.linkApps.enable = false;}
  ];
}
