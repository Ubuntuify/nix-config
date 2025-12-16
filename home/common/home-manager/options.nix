{lib, ...} @ args: {
  options.custom = {
    # Machine-specific options, such as mitigating for low RAM or whether graphical applications should be enabled
    # in the config
    machine = {
      graphics = let
        isNixDarwin = builtins.hasAttr "darwinConfig" args;
      in
        lib.mkOption {
          type = lib.types.bool;
          description = "Whether to enable graphical applications, such as Firefox or Alacritty.";
          default = args.nixosConfig.hardware.graphics.enable or isNixDarwin; # this is making an assumption that
          # all nix-darwin setups are for development only and not for server use.
        };

      isLowRam = lib.mkEnableOption "some low RAM mitigation features, such as auto-tab-discard, etc.";
    };

    # Linux-specific options, these have no effect when not on a Linux machine.
    linux = {
      window-manager = lib.mkOption {
        type = lib.types.enum ["sway" "hyprland" null];
        description = "Which window manager (and respective config) to use.";
        default = "sway";
      };
    };
  };
}
