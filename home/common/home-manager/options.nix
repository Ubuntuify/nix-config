{lib, ...} @ args: {
  options.custom = {
    machine = {
      graphics = let
        isNixDarwin = builtins.hasAttrs "darwinConfig" args;
      in
        lib.mkOption {
          type = lib.types.bool;
          description = "Whether to enable graphical applications, such as Firefox or Alacritty.";
          default = args.nixosConfig.hardware.graphics.enable or isNixDarwin;
        };
      isLowRam = lib.mkEnableOption "some low RAM mitigation features, such as auto-tab-discard, etc.";
    };
    linux = {
      window-manager = lib.mkOption {
        type = lib.types.enum ["sway" "hyprland" null];
        description = "Which window manager (and respective config) to use.";
        default = "sway";
      };
    };
  };
}
