{
  # basic git settings
  programs.git = {
    enable = true;
    userEmail = "ryanconrad2007@gmail.com";
    userName = "Ryan Salazar";

    aliases = {
      "a" = "add -A";
    };
  };

  # adds and configures lazygit
  programs.lazygit = {
    enable = true;
    settings = {
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
}
