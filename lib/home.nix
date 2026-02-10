{
  self,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
in {
  mkUserModules = users: system: builtins.map (u: outputs.lib.__internal__.getUserCfgs u ../home system) users;

  mkActiveHomeManagerConfigModules = users:
    builtins.map (user: {
      home-manager.users.${user} = outputs.lib.home.mkHomeEntry {inherit user;};
    })
    users;

  mkUserModuleWithHomeManager = users: system:
    builtins.concatLists [
      (outputs.lib.home.mkActiveHomeManagerConfigModules users)
      (outputs.lib.home.mkUserModules users)
    ];

  mkHomeEntry = {
    user,
    options ? {},
  }:
    lib.mkMerge ((outputs.lib.home.mkHomeModules ../home user) ++ [{custom = options;}]);

  mkTopLevelHomeCfg = {
    user,
    options ? {},
  }:
    outputs.lib.home.mkHomeConfiguration ../home user options;

  # Creates a home-manager configuration (to put out as outputs.homeConfiguration) using
  # included functions.
  mkHomeConfiguration = pathToHomeModules: user: options:
    inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit self inputs outputs;};
      modules =
        outputs.lib.__internal__.mkHomeModules pathToHomeModules user
        # Imports modules from mkHomeModules, leaving one implementation, mkHomeModules are often
        # used with home-manager's NixOS and nix-darwin plugins, while this is left for usage with
        # a standalone setup.
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
    ++ (outputs.lib.__internal__.getCommonModulePaths (pathToHomeModules + "/common/home-manager"));
}
