{
  pkgs,
  config,
  ...
}: {
  imports = [../../common/activate-lix.nix];

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

  programs.fish.enable = true;
}
