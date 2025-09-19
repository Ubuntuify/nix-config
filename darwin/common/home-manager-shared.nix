{
  pkgs,
  lib,
  config,
  ...
}: {
  home-manager.sharedModules = [
    (
      {...}: {
        # Disables home-manager's default linking method for applications,
        # to fix home-manager issue #1341.
        targets.darwin.linkApps.enable = false;
      }
    )
  ];

  # Hooks into nix-darwin's default linking method to include home-manager
  # applications, to fix issues with spotlight
  system.build.applications = lib.mkForce (
    pkgs.buildEnv {
      name = "system-applications";
      pathsToLink = "/Applications";
      paths =
        config.environment.systemPackages
        ++ (lib.concatMap (x: x.home.packages) (lib.attrsets.attrValues config.home-manager.users));
    }
  );
}
