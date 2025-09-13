# Kept for backwards compatibility, and is a naive approach
# to importing home-manager plugins.
#
# If you are specifying a specific machine's home-manager
# config, always default to specifying the modules directly.
{...}: {
  imports = [
    ./common.nix
    ./graphical.nix
  ];
}
