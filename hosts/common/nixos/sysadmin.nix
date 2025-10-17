{
  config,
  lib,
  ...
}: {
  config.users.users.${config.custom.systemUser} = lib.mkDefault {
    isNormalUser = true;
    createHome = true;

    # Gives the system administrator, at least some basic privillege escalation permissions
    # (but should be overrided by the user module themselves, located at
    # GIT_ROOT/home/<username>/nixos/user.nix
    extraGroups = ["wheel"];

    initialHashedPassword = "$y$j9T$0KS1HvfTNA3g5INykT7iJ0$1Nu2k0Cm5FgQl7x81dF4vd46bE9wCUbvXjCJf6GPSP0";
    # does not need to be kept as a secret, as this should only be available when the user has
    # not setup their config appropriately.
  };
}
