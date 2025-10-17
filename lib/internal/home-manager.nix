{
  self,
  inputs,
  outputs,
  ...
}: {
  # Creates a home-manager configuration (to put out as outputs.homeConfiguration) using
  # included functions.
  mkHomeConfiguration = pathToHomeModules: user: options:
    inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit self inputs outputs;};
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
  mkHomeModules = pathToHomeModules: user:
    [
      (builtins.toPath (pathToHomeModules + "/${user}/home-manager/default.nix"))
    ]
    ++ (outputs.lib.internal.getCommonModulePaths (pathToHomeModules + "/common/home-manager"));
}
