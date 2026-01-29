# Sole configuration of available systems.
# Creates configurations dynamically based on what is inside the hosts/nixos and hosts/darwin folders.
{
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
in {
  nixosConfigurations = let
    mkNixosSystems = systemPath: let
      systems = builtins.readDir (builtins.toPath systemPath);
    in
      builtins.mapAttrs (host: type:
        if (type == "directory")
        then let
          systemMetadata = builtins.fromTOML (builtins.readFile (systemPath + "/${host}/system.toml"));
          inherit (systemMetadata) system;
        in
          outputs.lib.sysconfig.mkNixos {
            system = system.architecture or "x86_64-linux";
            hostname = system.hostname or host;
            sysadmin = lib.mkIf (builtins.hasAttr "users" systemMetadata) systemMetadata.users.sysadmin;
          }
        else null)
      systems;
  in
    mkNixosSystems ./hosts/nixos;

  darwinConfigurations = let
    mkDarwinSystems = systemPath: let
      systems = builtins.readDir (builtins.toPath systemPath);
    in
      builtins.mapAttrs (host: type:
        if (type == "directory")
        then let
          systemMetadata = builtins.fromTOML (builtins.readFile (systemPath + "/${host}/system.toml"));
        in
          outputs.lib.sysconfig.mkDarwin {
            hostname = systemMetadata.system.hostname or host;
            sysadmin = systemMetadata.users.sysadmin or "ryans";
            system = systemMetadata.system.architecture or "aarch64-darwin"; # set the default to Apple Silicon, because who uses an actual x86_64 Mac anyways (unless it's a Hackintosh or something)
          }
        else null)
      systems;
  in
    mkDarwinSystems ./hosts/darwin;
}
