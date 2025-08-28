{ config, ... }:

{
  programs.lf = {
    enable = true;
    extraConfig = ''
      set icons
    '';
  };

  home.file = {
    "${config.xdg.configHome}/lf/icons".source = ./icons;
    "${config.xdg.configHome}/lf/colors".source = ./colors;
  };

  programs.fish.functions = {
    lfcd = {
      wraps = "lf";
      description = "lf - Terminal file manager (changing directory on exit)";
      body = "cd \"$(command lf -print-last-dir $argv)\"";
    };
  };
}
