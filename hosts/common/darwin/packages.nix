{
  homebrew.brews = [
    "lujstn/tap/pinentry-touchid" # touch-id for gnupg verification/unlock (fixed varient)
    "mas" # messing around with the App Store, and downloading applications
  ];

  security.pam.services.sudo_local = {
    # enables sudo touch id support
    enable = true;
    touchIdAuth = true;
  };
}
