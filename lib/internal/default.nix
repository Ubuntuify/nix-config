{
  inputs,
  outputs,
  ...
}: let
in {
  mkHomeConfiguration = pathToHomeModules: user: options:
    inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit inputs outputs;};
      modules =
        outputs.lib.internal.mkHomeModules pathToHomeModules user
        ++ [
          {custom = options;} # Set custom options;
        ];
    };

  # This expects things to be laid out in a certain manner. The following directories *must*
  # exist.
  #
  # <pathToHomeModules>/common/home-manager/*.nix (It will import all modules under this)
  # <pathToHomeModules>/<user>/home-manager/default.nix (You can lay out your modules anyway you
  # - want, there's no certain way to do it here.)
  mkHomeModules = pathToHomeModules: user: let
    getCommonModulePaths = path: builtins.map (file: builtins.toPath (path + "/${file}")) (builtins.attrNames (builtins.readDir path));
  in
    [
      (builtins.toPath (pathToHomeModules + "/${user}/home-manager/default.nix"))
    ]
    ++ (getCommonModulePaths (pathToHomeModules + "/common/home-manager"));
}
