{pkgs, ...}: {
  programs.lf = {
    enable = true;
    previewer.source = pkgs.writeScript "pv.fish" (builtins.readFile ./lf/previewer.fish);

    settings = {
      icons = true;
      sixel = true;
      drawbox = true;
      mouse = true;
    };

    keybindings = {
      # basic utilities (such as: rename, mkdir, touch, etc.)
      "<f-2>" = "rename";
      "a" = ":push %mkdir<space>";
      "t" = ":push %touch<space>";

      # toggling hidden
      "<backspace>" = "set hidden!";
      "." = "set hidden!";
    };

    extraConfig = ''
      # The file is a configuration file to be added onto lf's config,
      # when home-manager does not provide sufficient settings.

      setlocal ~/Downloads/ sortby ctime
    '';
  };

  xdg.configFile = {
    "lf/icons".source = ./lf/icons; # put icons file in lf config (from src repo)
    "lf/colors".source = ./lf/colors; # put colors file in lf config (from src repo)
  };

  # adds fish integration
  programs.fish.functions.lfcd = {
    wraps = "lf";
    description = "lf - Terminal file manager (changing directory on exit)";
    body = "cd \"$(command lf -print-last-dir $argv)\"";
  };

  home.sessionVariables.GROFF_NO_SGR = 1;

  # adds required pkgs for previewer.sh (see ./previewer.fish)
  programs.bat.enable = true;
  home.packages = [pkgs.chafa pkgs.poppler-utils pkgs.file];
}
