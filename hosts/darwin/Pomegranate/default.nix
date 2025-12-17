{outputs, ...}: let
  inherit (outputs) overlays;
  inherit (outputs.lib) modules;
in {
  imports =
    [
      ./system-specific/dock.nix
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
    WindowManager = {
      EnableTilingByEdgeDrag = false; # should be taken over by cask 'Rectangle'
    };
  };

  programs.fish.enable = true;

  system.stateVersion = 6;
}
