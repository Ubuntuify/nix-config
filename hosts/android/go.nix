{
  pkgs,
  libx,
  ...
}: {
  imports = [../common/activate-lix.nix];

  home-manager.config = libx.mkHome {};
  user.shell = pkgs.fish;
}
