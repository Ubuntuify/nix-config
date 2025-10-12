{
  pkgs,
  lib,
  ...
}: {
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
    nix-tree
  ];

  # Checks if Lix is present, and enables the option required for what this flake requires
  # (submodule support) through inputs.self.submodules.
  nix.settings.experimental-features = let
    inherit (builtins) nixVersion;
  in
    lib.optionals ((builtins.substring ((builtins.stringLength nixVersion) - 3) 3 nixVersion) == "lix") ["flake-self-attrs"];
}
