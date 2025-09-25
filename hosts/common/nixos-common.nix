{systemUser, ...}: {
  # nix settings (includ. optimizations, automatic garbage collection)
  nix = {
    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      max-substitution-jobs = 64;
      http-connections = 64;
    };
  };

  programs.command-not-found.enable = true;

  # Nix can start taking a lot of space, as it doesn't remove old versions of
  # packages automatically. Since we're already using nh (yet another nix CLI
  # helper), use that to clean up.
  programs.nh = {
    enable = true;
    flake = "/home/${systemUser}/.local/share/nix-config";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--verbose --keep-since 7d --optimise";
    };
  };
}
