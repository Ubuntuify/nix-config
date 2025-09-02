{pkgs, ...}: {
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
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "transient-fish";
        src = pkgs.fishPlugins.transient-fish.src;
      }
      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
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

  # enable requirements for plugin fzf-fish (see above and its README)
  programs.fzf.enable = true;
  programs.fd.enable = true;

  home.sessionVariables.sponge_purge_only_on_exit = 1;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
