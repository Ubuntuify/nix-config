{pkgs, ...}: {
  programs.lf = {
    enable = true;
    previewer.source = pkgs.writeScript "pv.fish" (builtins.readFile ./previewer.fish);

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

    extraConfig = builtins.readFile ./config.lfrc; # point to separate file
  };

  xdg.configFile = {
    "lf/icons".source = ./icons; # put icons file in lf config (from src repo)
    "lf/colors".source = ./colors; # put colors file in lf config (from src repo)
  };

  # adds fish integration
  programs.fish.functions.lfcd = {
    wraps = "lf";
    description = "lf - Terminal file manager (changing directory on exit)";
    body = "cd \"$(command lf -print-last-dir $argv)\"";
  };

  # adds required pkgs for previewer.sh (see ./previewer.sh)
  programs.bat.enable = true;
  home.packages = [pkgs.chafa pkgs.poppler-utils];
}
