{
  outputs,
  modules,
  ...
}: let
  inherit (outputs) overlays;
in {
  imports =
    [
      ./system-specific/dock.nix
      modules.drawing
    ]
    ++ (outputs.lib.__internal__.getUserCfgs ["ryans"] ../../../home "darwin");

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
