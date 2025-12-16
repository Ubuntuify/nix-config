{
  pkgs,
  lib,
  config,
  ...
} @ args: let
  pinentryPackage =
    if !pkgs.stdenv.isDarwin
    then pkgs.pinentry-tty
    else pkgs.pinentry_mac;
in {
  programs.git = {
    enable = true;

    settings = {
      user = {
        email = "ryanconrad2007@gmail.com";
        name = "Ryan Salazar";
      };

      aliases = {
        "a" = "add --all";
        "p" = "push";
        "pf" = "push --force";
      };

      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    };

    signing.format = "openpgp";
    signing.signByDefault = true;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      # rose-pine theme
      # src: https://github.com/rose-pine/lazygit/blob/main/themes/rose-pine-moon.yml
      # converted into nix

      gui.theme = {
        activeBorderColor = ["#3e8fb0" "bold"];
        inactiveBorderColor = ["#6e6a86"];
        searchingActiveBorderColor = ["#ea9a97" "bold"];
        optionsTextColor = ["#9ccfd8"];
        selectedLineBgColor = ["#3e8fb0"];
        inactiveViewSelectedBgColor = ["#393552" "bold"];
        cherryPickedCommitFgColor = ["#2a273f"];
        cherryPickedCommitBgColor = ["#ea9a97"];
        markedBaseCommitFgColor = ["#9ccfd8"];
        markedBaseCommitBgColor = ["#f6c177"];
        unstagedChangesColor = ["#eb6f92"];
        defaultFgColor = ["#e0def4"];
      };

      gui.nerdFontsVersion = "3"; # enable nerd font glyphs

      tabwidth = 2;
      border = "single"; # don't use a rounded border

      spinner = {
        frames = ["⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"];
        rate = 80;
      };

      commit = {
        signOff = true;
        autoWrapCommitMessage = true;
        autoWrapWidth = 72;
      };

      merging = {
        manualCommit = true;
        squashMergeMessage = "Squash merge {{selectedRef}} into {{currentBranch}}";
      };

      mainBranches = ["main" "master"];

      os = {
        edit = "nvim {{filename}}";
        editAtLine = "nvim {{filename}} +{{line}}";
        editAtLineAndWait = "nvim {{filename}} +{{line}}";
      };
    };
  };
  programs.fish.shellAliases.lg = "lazygit";

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package =
      if builtins.hasAttr "darwinConfig" args
      then null
      else pinentryPackage;
    extraConfig = lib.mkIf (builtins.hasAttr "darwinConfig" args) ''
      pinentry-program ${args.darwinConfig.homebrew.brewPrefix}/pinentry-touchid
    '';
  };

  home.packages = [pkgs.onefetch pinentryPackage];
}
