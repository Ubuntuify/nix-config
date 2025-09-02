{
  vim.enableLuaLoader = true;

  # configure theme
  vim.theme = {
    enable = true;
    name = "rose-pine";
    style = "main";
  };

  # enable plugins
  vim.diagnostics.enable = true;
  vim.lsp.enable = true;

  vim.statusline.lualine.enable = true;
  vim.telescope.enable = true;
  vim.autocomplete.blink-cmp.enable = true;
  vim.utility.sleuth.enable = true;
  vim.autopairs.nvim-autopairs.enable = true;
  vim.visuals.fidget-nvim.enable = true;
  vim.filetree.neo-tree.enable = true;

  # settings
  vim.diagnostics.config = {
    virtual_text = true;
    signs = true;
    update_in_insert = true;
  };

  vim.lsp = {
    formatOnSave = true;
    inlayHints.enable = true;
    lspkind.enable = true;
    lspconfig.enable = true;
  };

  vim.filetree.neo-tree.setupOpts = {
    enable_cursor_hijack = true;
    git_status_async = true;
  };

  vim.languages = import ./languages.nix; # separate languages from nvf-config for easier changes;
}
