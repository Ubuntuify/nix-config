{
  inputs,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.ryan = {
      extensions = with inputs.firefox-addons.packages.${pkgs.stdenv.system}; [
        ublock-origin-upstream
        rust-search-extension
        sponsorblock
        return-youtube-dislikes
      ];
    };
  };
}
