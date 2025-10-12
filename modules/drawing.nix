{
  pkgs,
  options,
  outputs,
  ...
}:
outputs.lib.mkMultiSystemModule {
  inherit pkgs options;
  nixosModule = {
    # Provide Krita to all users through home-manager, while keeping it in userspace.
    # Home Manager is guaranteed to be loaded through the mkNixos and mkDarwin helper
    # modules.
    home-manager.sharedModules = [
      {home.packages = [pkgs.krita];}
    ];
    hardware.opentabletdriver.enable = true;
  };
  darwinModule = {
    # OpemTabletDriver and Krita is marked as broke on Darwin systems, forcing us to
    # use the respective homebrew casks.

    # This only applies to Wacom tablets, and you may need to switch the cask if you
    # are using a different drawing tablet.
    homebrew.casks = ["wacom-tablet" "krita"];
  };
}
