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
          outputs.lib.helpers.mkNixos {
            system = system.architecture;
            hostname = system.hostname or host;
            systemUser = lib.mkIf (builtins.hasAttr "users" systemMetadata) systemMetadata.users.sysadmin;
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
          outputs.lib.helpers.mkDarwin {
            hostname = systemMetadata.system.hostname or host;
            username = systemMetadata.users.sysadmin or "ryans";
          }
        else null)
      systems;
  in
    mkDarwinSystems ./hosts/darwin;
}
