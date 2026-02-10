{
  self,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;

  # These are extra modules that will allow configuring both nix-darwin and NixOS systems.
  modules = let
    inherit (inputs.haumae) lib;
  in
    lib.load {
      src = ../modules;
      loader = lib.loaders.verbatim;
    };

  # These are modules required to create Darwin and NixOS systems, mess with them wisely and expect
  # either breakage, or heavy refactoring, depending on how much the behavior is relied upon.
  mkCommonModule = hostname: sysadmin: {
    custom.systemUser = sysadmin;
    networking.hostName = lib.mkDefault hostname;
    system.configurationRevision = self.rev or "dirty-${self.lastModifiedDate}";
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
  universalCommonModules = outputs.lib.__internal__.getCommonModulePaths ../hosts/common;
  specialArgs = {inherit self inputs outputs modules;};
in {
  mkDarwin = {
    hostname,
    sysadmin ? "ryan", # TODO: make it pass the entire config to handle more code here
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
        ++ (outputs.lib.__internal__.getCommonModulePaths ../hosts/common/darwin) ++ universalCommonModules;
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
        ++ (outputs.lib.__internal__.getCommonModulePaths ../hosts/common/nixos) ++ universalCommonModules;
    };
}
