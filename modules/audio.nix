{
  services.pipewire = {
    enable = true;

    # Pipewire pipes into other protocols for compatibility with older applications.
    # Other options include JACK, which are disabled here to save on space.
    pulse.enable = true;
    alsa.enable = true;
  };
}
