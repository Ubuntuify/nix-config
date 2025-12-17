{
  pkgs,
  config,
  ...
}: {
  system.defaults.dock = {
    persistent-apps = [
      {app = "${pkgs.firefox}/Applications/Firefox.app";}
      {app = "/System/Applications/Mail.app";}
      {app = "${pkgs.alacritty}/Applications/Alacritty.app";}
      {app = "/Applications/Discord.app";}
      {app = "/System/Applications/App Store.app";}
    ];
    persistent-others = ["/Users/${config.system.primaryUser}/Documents" "/Users/${config.system.primaryUser}/Downloads"];
    autohide = true;
    minimize-to-application = true;
    mru-spaces = false;
    show-recents = false;
  };
}
