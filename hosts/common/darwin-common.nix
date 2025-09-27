{
  pkgs,
  lib,
  config,
  ...
}: {
  system.stateVersion = 6; # set stateVersion here, for aforementioned reasons

  # install homebrew and macos apps
  homebrew = {
    enable = true;
    brews = [
      "lujstn/tap/pinentry-touchid" # use pinentry-touchid; fixed varient
      "mas"
    ];
    casks = [
      "rectangle"
      "calibre" # calibre package is marked broken in nixpkgs for darwin systems
      "discord"
      {
        name = "grishka/grishka/neardrop";
        args = {no_quarantine = true;};
      }
    ];
    masApps = {
      "DaVinci Resolve" = 571213070;
    };
    onActivation.cleanup = "zap";
  };

  environment.systemPackages = [];

  # turn on touch id for sudo
  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
  };

  # nix settings
  nix.enable = true;
  nix.optimise.automatic = true;

  # workaround https://github.com/nix-community/home-manager/issues/1341
  home-manager.sharedModules = [{targets.darwin.linkApps.enable = false;}];
  system.build.applications = lib.mkForce (
    pkgs.buildEnv {
      name = "system-applications";
      pathsToLink = "/Applications";
      paths = config.environment.systemPackages ++ (lib.concatMap (x: x.home.packages) (lib.attrsets.attrValues config.home-manager.users));
    }
  );
}
