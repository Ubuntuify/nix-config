{
  config,
  lib,
  ...
}: {
  config.users.users.${config.custom.systemUser} = {
    isNormalUser = lib.mkDefault true;
    createHome = lib.mkDefault true;

    # Gives the system administrator, at least some basic privillege escalation permissions
    # Force the group to have the "wheel" group for sudo privillege.
    extraGroups = lib.mkForce ["wheel"];

    initialHashedPassword = lib.mkDefault "$y$j9T$0KS1HvfTNA3g5INykT7iJ0$1Nu2k0Cm5FgQl7x81dF4vd46bE9wCUbvXjCJf6GPSP0";
    # does not need to be kept as a secret, as this should only be available when the user has
    # not setup their config appropriately; or if mutableUsers is equal to true.
  };
}
