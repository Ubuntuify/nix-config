{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.home-manager-options;
  firefox-addons = inputs.nur.legacyPackages.${pkgs.stdenv.system}.repos.rycee.firefox-addons;
in
  lib.mkIf cfg.system.graphical (lib.mkMerge [
    {
      programs.firefox = {
        enable = true;
        profiles.ryan = {
          extensions.packages = with firefox-addons; [
            ublock-origin-upstream
            chrome-mask
            rust-search-extension
            sponsorblock
            return-youtube-dislikes
          ];
        };
      };
    }
    (lib.mkIf pkgs.stdenv.isLinux {
      xdg.mimeApps = {
        enable = true;
        associations.added = {
          "application/pdf" = ["firefox.desktop"];
        };
      };
    })
  ])
