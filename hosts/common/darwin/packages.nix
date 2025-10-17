{
  homebrew.brews = [
    "lujstn/tap/pinentry-touchid" # touch-id for gnupg verification/unlock (fixed varient)
    "mas" # messing around with the App Store, and downloading applications
  ];

  homebrew.casks = [
    "rectangle"
    "calibre"
    "discord"
    {
      name = "griska/griska/neardrop";
      args = {no_quarantine = true;};
    }
  ];

  homebrew.masApps = {
    # These are Mac Store applications, defined with an ID.
    "DaVinci Resolve" = 571213070;
  };

  security.pam.services.sudo_local = {
    # enables sudo touch id support
    enable = true;
    touchIdAuth = true;
  };
}
