{pkgs, ...}: {
  fonts.packages = with pkgs; [
    # Install Windows fonts.
    corefonts
    vista-fonts

    # Other open source fonts.
    noto-fonts
    font-awesome
    joypixels
    open-sans
    jetbrains-mono
  ];

  # Joypixels is a "fremium" emoji font, therefore requires a license agreement.
  nixpkgs.config.joypixels.acceptLicense = true;
  nixpkgs.config.allowUnfree = true;
}
