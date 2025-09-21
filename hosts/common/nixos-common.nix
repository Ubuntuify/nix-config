{...}: {
  # nix settings
  nix.optimise.automatic = true;

  nix.settings = {
    auto-optimise-store = true;
    max-substitution-jobs = 64;
    http-connections = 64;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
