{
  services.displayManager.ly = {
    enable = true;
    settings = {}; # settings is broken for some reason (as in, setting anything seems to
    # destroy ly's ability to find stuff, etc.) TODO: debug
  };

  systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
}
