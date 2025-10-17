{
  self,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  supportedSystems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];

  # These are modules required to create Darwin and NixOS systems, mess with them wisely and expect
  # either breakage, or heavy refactoring, depending on how much the behavior is relied upon.
  mkCommonModule = hostname: sysadmin: {
    custom.systemUser = sysadmin;
    networking.hostName = lib.mkDefault hostname;
    system.configurationRevision = self.rev or "dirty-${self.lastModifiedDate}";
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
  universalCommonModules = outputs.lib.internal.getCommonModulePaths ../hosts/common;
  specialArgs = {inherit self inputs outputs;};
in {
  forEachSupportedSystem = f:
    lib.genAttrs supportedSystems (system:
      f {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      });

  mkDarwin = {
    hostname,
    sysadmin ? "ryan",
    system ? "aarch64-darwin",
  }: let
    hostSpecificConfPath = builtins.toString ../hosts/darwin/${hostname}/default.nix;
    hostSpecificConf =
      if builtins.pathExists hostSpecificConfPath
      then hostSpecificConfPath
      else
        (lib.warn "Host specific configuration (dock) does not exist, falling back to common dock config."
          ../hosts/common/darwin/defaults/dock.nix);
  in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules =
        [
          (mkCommonModule hostname sysadmin)
          hostSpecificConf
        ]
        ++ (outputs.lib.internal.getCommonModulePaths ../hosts/common/darwin) ++ universalCommonModules;
    };

  mkNixos = {
    hostname,
    sysadmin ? "nixos",
    system ? "x86_64-linux",
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules =
        [
          (mkCommonModule hostname sysadmin)
          ../hosts/nixos/${hostname}/default.nix
        ]
        ++ (outputs.lib.internal.getCommonModulePaths ../hosts/common/nixos) ++ universalCommonModules;
    };

  mkHomeEntry = {
    user,
    options ? {},
  }:
    lib.mkMerge ((outputs.lib.internal.mkHomeModules ../home user) ++ [{custom = options;}]);

  mkTopLevelHomeCfg = {
    user,
    options ? {},
  }:
    outputs.lib.internal.mkHomeConfiguration ../home user options;
}
