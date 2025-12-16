{outputs, config, lib, ...}: let
  user = "ryan";
in {
  # Windows (which I derive my NixOS username from) has different naming
  # user conventions compared to Unix-based systems.
  #
  # Such as the fact that the last name is not included as part of the
  # "username" part of it.
  options.custom.overrideUsername = lib.mkOption {
    type = lib.types.string;
  };

  config = {
    users.users.${user} = {
      # nix-darwin's "The Plan" should allow me to set more configuration, such as Docks,
      # Preferences, and other settings in here later on. You can probably do with
      # home-manager, but I prefer my setups more specialized on MacOS, and make sure
      # MacOS specific changes in a different file.
      #
      # - tracking issue: nix-darwin/nix-darwin#1452 -

      name = "${user}";
      description = "Ryan Salazar";
      home = "/Users/${user}";
    };

    home-manager.users.${user} = outputs.lib.system.mkHomeEntry {
      user = "ryans"; # use *this* specific configuration
    };
  };
}
