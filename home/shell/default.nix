{ pkgs, ... }:

{
  # This uses fish as the default shell, if you don't like that, do not use this module
  # and remove its import.
  programs.fish = {
    enable = true;
    generateCompletions = true;

    shellAliases = {
      sudo = "doas";
    };

    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
  };

  # Workaround the fact that fish is not a POSIX complaint shell, and
  # therefore will not work with some features such as systemd's emergency
  # mode.
  programs.bash = {
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
