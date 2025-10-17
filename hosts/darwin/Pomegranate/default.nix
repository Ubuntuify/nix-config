{
  outputs,
  pkgs,
  config,
  ...
}: let
  inherit (outputs) overlays;
  inherit (outputs.lib) modules;
in {
  imports =
    [
      modules.drawing
    ]
    ++ (outputs.lib.system.darwin.mkUserModules ["ryans"]);

  nixpkgs.overlays = [
    overlays.lix
  ];

  system.defaults = {
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleShowScrollBars = "Always";
    };
    dock = {
      persistent-apps = [
        {app = "${pkgs.firefox}/Applications/Firefox.app";}
        {app = "/System/Applications/Mail.app";}
        {app = "${pkgs.alacritty}/Applications/Alacritty.app";}
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

  system.stateVersion = 6;
}
