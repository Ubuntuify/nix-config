{
  pkgs,
  libx,
  ...
}: {
  home-manager.config = libx.mkHome {};
  user.shell = pkgs.fish;
}
