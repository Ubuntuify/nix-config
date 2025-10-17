{config, ...}: {
  system.primaryUser = config.custom.systemUser; # this will be removed in a future version of nix-darwin.

  # NixOS systems operate very differently from nix-darwin systems, even with their
  # similarities. MacOS systems have an "owner," which is the first account made
  # during the MacOS system flow.
  #
  # The system user (or primary user/sysadmin) should therefore already exist, and
  # all we really need to set is their home and their name, which should be passed
  # in as an argument using the helper functions.
  users.users.${config.custom.systemUser} = {
    name = config.custom.systemUser;
    home = "/Users/${config.custom.systemUser}";
  };
}
