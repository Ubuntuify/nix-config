{
  pkgs,
  config,
  ...
}: {
  # Everything in the dock should be defined in the common packages located in darwin-common.nix
  system.defaults.dock = {
    persistent-apps = [
      "${pkgs.firefox}/Applications/Firefox.app"
      "/System/Applications/Mail.app"
      "/Applications/Discord.app"
      "/System/Applications/App Store.app"
      "/System/Applications/Journal.app"
    ];
    persistent-others = [
      # workaround: this shouldn't work after system.primaryUser is removed, but for now it should work
      # while expansion for persistent-others is not yet defined.
      "/Users/${config.system.primaryUser}/Documents"
      "/Users/${config.system.primaryUser}/Downloads"
    ];
  };
}
