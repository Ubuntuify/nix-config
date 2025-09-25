{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nh # nix cli helper written in rust, faster than nixos-rebuild-ng
    aria2
    ffmpeg
    imagemagick
    dua # modern 'du' equivalent
    duf # modern 'df' equivalent
    lstr # modern 'tree' equivalent
    git
    wget2
    curl
    uv
  ];
}
