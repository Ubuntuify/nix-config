{
  pkgs,
  config,
  ...
}: {
  system.defaults.dock = {
    # Everything in the dock should be defined within ../common-pkgs.nix (as if it doesn't,
    # it will lead to a broken reference).
    #
    # Applications from the Nix Store (as in, installed as a nixpkg) should be referred to
    # directly as its nix store reference. This project relies on mac-app-util to take care
    # of trampolines and other Spotlight issues that come with Nix using symlinks in its
    # environment.
    persistent-apps = [
      "${pkgs.firefox}/Applications/Firefox.app"
      "/System/Applications/Mail.app"
      "/Applications/Discord.app"
      "/System/Applications/App Store.app"
      "/System/Applications/Journal.app"
    ];

    persistent-others = [
      # Workaround: this shouldn't work after system.primaryUser is removed, but for now it
      # should work while expansion for persistent-others is not yet defined.
      #
      # - Tracking issue: nix-darwin/nix-darwin#968 -
      "/Users/${config.system.primaryUser}/Documents"
      "/Users/${config.system.primaryUser}/Downloads"
    ];
  };
}
