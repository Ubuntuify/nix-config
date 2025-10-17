{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.nh # nix cli helper written in rust, faster than nixos-rebuild-ng
    pkgs.aria2
    pkgs.ffmpeg
    pkgs.imagemagick
    pkgs.dua # modern 'du' equivalent
    pkgs.duf # modern 'df' equivalent
    pkgs.lstr # modern 'tree' equivalent
    pkgs.git
    pkgs.wget2
    pkgs.curl
    pkgs.uv
    pkgs.nix-tree
  ];
}
