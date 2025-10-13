# Sole configuration of available systems.
# Creates configurations dynamically based on what is inside the hosts/nixos and hosts/darwin folders.
{
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  mkNixosSystems = systemPath: let
    systems = builtins.readDir (builtins.toPath systemPath);
  in
    builtins.mapAttrs (host: type:
      if (type == "directory")
      then let 
          systemMetadata = (builtins.fromTOML (builtins.readFile (systemPath + "/${host}/system.toml")));
          inherit (systemMetadata) system;
        in outputs.lib.mkNixos {
            system = system.architecture;
            hostname = system.hostname;
            systemUser = lib.mkIf (builtins.hasAttr "users" systemMetadata) systemMetadata.users.sysadmin;
          }
      else null)
    systems;
in {
  nixosConfigurations = mkNixosSystems ./hosts/nixos;
}
