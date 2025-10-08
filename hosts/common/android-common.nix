{pkgs, ...}: {
  # Nix on Droid functions very differently from NixOS and nix-darwin, and such the modules there cannot be used on Nix on Droid
  # This is not a bug, and is intended behavior, therefore all packages for android should be defined here again, even if they're
  # available in ./common-packages.nix

  terminal.font = let
    fontDirectory = "fonts/truetype";
  in "${pkgs.nerd-fonts.iosevka-term-slab}/share/${fontDirectory}/NerdFonts/IosevkaTermSlab/IosevkaTermSlabNerdFont-Medium.ttf";

  # Enable some Termux (Nix on Droid) features for compatibility.
  android-integration.am.enable = true;
  android-integration.termux-open.enable = true;
  android-integration.termux-open-url.enable = true;
  android-integration.termux-reload-settings.enable = true;
  android-integration.xdg-open.enable = true;

  environment.packages = let
  in
    with pkgs; [
      # These packages are taken from nixpkgs.
      nh
      aria2
      dua
      duf
      wget2
      nix-tree
      uv
    ];

  system.stateVersion = "24.05";
}
