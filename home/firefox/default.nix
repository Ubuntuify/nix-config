{inputs, ...}: {
  programs.firefox = {
    enable = true;
    profiles.ryan = {
      extensions = [
        inputs.firefox-addons.${builtins.currentSystem}.ublock-origin-upstream
      ];
    };
  };
}
