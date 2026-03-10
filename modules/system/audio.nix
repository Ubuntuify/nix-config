{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.pwvucontrol];

  services.pipewire = {
    enable = true;

    # Pipewire pipes into other protocols for compatibility with older applications.
    # Other options include JACK, which are disabled here to save on space.
    pulse.enable = true;
    alsa.enable = true;

    # Not recommended, but I want systemwide audio.
    #systemWide = lib.mkDefault true;
  };

  # Support for Easy Effects to improve sound quality.
  programs.dconf.enable = true;
  home-manager.sharedModules = [
    {services.easyeffects.enable = lib.mkDefault true;}
  ];
}
