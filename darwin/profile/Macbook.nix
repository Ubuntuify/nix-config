{
  self,
  pkgs,
  config,
  lib,
  mkHomeModules,
  ...
}: let
  user = "ryan"; # The main user of this system, this user will own both the home-manager
  # configuration, but also the homebrew setup.
in {
  imports = [
    ../common/home-manager-shared.nix
  ];

  # home-manager configuration
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.${user} = lib.mkMerge (mkHomeModules {
    inherit user;
    system.graphical = true;
  });

  # user configuration
  system.primaryUser = user;
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };
  programs.fish.enable = true;

  nix-homebrew = {
    inherit user;
    enable = true;
    autoMigrate = true; # use existing homebrew configuration
  };

  homebrew = {
    enable = true;
    brews = [
      "lujstn/tap/pinentry-touchid"
    ];
    casks = [
      "rectangle"
      "calibre"
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

  system.defaults = {
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleShowScrollBars = "Always";
    };
    dock = {
      persistent-apps = [
        {app = "/Applications/Nix Apps/Firefox.app";}
        {app = "/System/Applications/Mail.app";}
        {app = "/Applications/Nix Apps/Alacritty.app";}
        {app = "/Applications/Discord.app";}
        {app = "/System/Applications/App Store.app";}
      ];
      persistent-others = ["/Users/${config.system.primaryUser}/Documents" "/Users/${config.system.primaryUser}/Downloads"];
      autohide = true;
      minimize-to-application = true;
      mru-spaces = false;
      show-recents = false;
    };
    WindowManager = {
      EnableTilingByEdgeDrag = false; # should be taken over by cask 'Rectangle'
    };
  };

  environment.systemPackages = [pkgs.ffmpeg_6 pkgs.aria2 pkgs.imagemagick pkgs.git];

  system.configurationRevision = self.rev or self.dirtyRev or null;

  nix.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  nix.optimise.automatic = true;

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
  };

  system.stateVersion = 6;
}
