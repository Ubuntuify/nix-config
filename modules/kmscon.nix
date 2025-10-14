{pkgs, ...}: {
  services.kmscon = {
    enable = true;
    hwRender = true;
    useXkbConfig = true;
    extraOptions = "--term xterm-256color";
    fonts = [
      {
        name = "Terminess Nerd Font Mono";
        package = pkgs.nerd-fonts.terminess-ttf;
      }
    ];
  };
}
