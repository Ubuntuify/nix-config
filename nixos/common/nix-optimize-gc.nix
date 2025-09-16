{...}: {
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;
  nix.settings.max-substitution-jobs = 64;
  nix.settings.http-connections = 64;
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";
}
