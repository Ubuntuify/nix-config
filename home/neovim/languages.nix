{
  enableTreesitter = true;
  enableFormat = true;

  # enabling required language support here
  # feel free to comment out unneeded language support for your usecase
  nix.enable = true;
  svelte.enable = true;
  ts.enable = true;
  rust.enable = true;
  python.enable = true;
  bash.enable = true;

  # specific configuration
  nix.lsp.server = "nixd";
  nix.lsp.options = {
    home_manager = {
    };
  };
}
