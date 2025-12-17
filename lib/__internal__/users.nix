{
  self,
  inputs,
  outputs,
}: let
  # Do not export getUserCfgModule as it won't be used outside of this Nix module.
  #
  getUserCfgModule = {
    user,
    path,
    system,
  }: ((builtins.toPath path) + "/${user}/${system}/user.nix");
in {
  # Creates a list that you can set to config.users.users by simply importing a list
  # of users you want to have in your system.
  #
  getUserCfgs = users: path: system:
    builtins.map (user: (getUserCfgModule {inherit user path system;})) users;
}
