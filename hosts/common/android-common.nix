{pkgs, ...}: {
  terminal.font = let
    fontDirectory = "fonts/truetype";
  in "${pkgs.nerd-fonts.iosevka-term-slab}/share/${fontDirectory}/NerdFonts/IosevkaTermSlab/IosevkaTermSlabNerdFont-Medium.ttf";

  # Enable some Termux (Nix on Droid) features for compatibility.
  android-integration.am.enable = true;
  android-integration.termux-open.enable = true;
  android-integration.termux-open-url.enable = true;
  android-integration.termux-reload-settings.enable = true;
  android-integration.xdg-open.enable = true;

  environment.packages = with pkgs; [
    nh
    aria2
    dua
    duf
    gitMinimal
    wget2
    nix-tree
    uv
  ];
}
