{
  config,
  lib,
  ...
}: {
  nix = {
    # Optimise automatically after build to save on space, this apparently may
    # corrupt the Nix store on nix-darwin, thus it is kept here in the NixOS only
    # configuration.
    optimise.automatic = lib.mkDefault true;

    settings = {
      auto-optimise-store = true;

      # This maximises the parallelization that happens on Nix, which is often set
      # to none what-so-ever (especially when building), making them non-deterministic
      # which is a big-no-no. Change if I'm wrong, should speed things up though.
      max-substitution-jobs = 64;
      http-connections = 64;
    };
  };

  programs.nh = {
    enable = lib.mkDefault true;

    # Set the default flake location to the system administrator's xdg share folder,
    # allowing for easier rebuilds.
    flake = "/home/${config.custom.systemUser}/.local/share/nix-config";

    # Substitute in-built nix-garbage-collect service with nh (yet another nix helper)
    # which seems to clean more things than standard.
    clean = {
      enable = true;
      dates = lib.mkDefault "weekly";
      extraArgs = lib.mkDefault "--verbose --keep-since 14d --optimise";
    };
  };
}
