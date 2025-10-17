{
  self,
  inputs,
  outputs,
  ...
}: let
  home = import ./home-manager.nix {inherit self inputs outputs;};
  users = import ./users.nix {inherit self inputs outputs;};
in {
  # General functions are kept here, while other functions which are specific to components are
  # inherited (imported) into this module;

  # Inherited functions
  inherit (home) mkHomeConfiguration mkHomeModules;
  inherit (users) getUserCfgs;

  # Simple functions
  getCommonModulePaths = path: let
    commonPathRead = builtins.readDir path;
  in
    builtins.map (file: builtins.toPath (path + "/${file}")) (builtins.filter (obj: commonPathRead.${obj} != "directory")
      (builtins.attrNames commonPathRead));
}
