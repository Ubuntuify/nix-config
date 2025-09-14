{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  isGraphical = config.hm-options.isGraphical;
  isLinux = pkgs.stdenv.isLinux;
in
  lib.mkMerge [
    (lib.mkIf isGraphical {
      programs.firefox = {
        enable = true;
        profiles.ryan = {
          extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.system}; [
            ublock-origin-upstream
            rust-search-extension
            sponsorblock
            return-youtube-dislikes
          ];
        };
      };
    })
    (lib.mkIf isLinux {
      xdg.mimeApps = {
        enable = true;
        associations.added = {
          "application/pdf" = ["firefox.desktop"];
        };
      };
    })
  ]
