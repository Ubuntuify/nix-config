{pkgs, ...}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim.enableLuaLoader = true;

      # configure theme
      vim.theme = {
        enable = true;
        name = "rose-pine";
        style = "main";
      };

      vim.options = {
        shiftwidth = 2;
        tabstop = 2;
        expandtab = true;
      };

      # enable plugins
      vim.diagnostics.enable = true;
      vim.lsp.enable = true;

      vim.statusline.lualine.enable = true;
      vim.telescope.enable = true;
      vim.autocomplete.blink-cmp.enable = true;
      vim.utility.sleuth.enable = true;
      vim.utility.images.image-nvim.enable = true;
      vim.autopairs.nvim-autopairs.enable = true;
      vim.visuals.fidget-nvim.enable = true;
      vim.filetree.neo-tree.enable = true;
      vim.git.gitsigns.enable = true;

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

      vim.utility.images.image-nvim.setupOpts = {
        backend = "sixel";
      };

      vim.filetree.neo-tree.setupOpts = {
        enable_cursor_hijack = true;
        git_status_async = true;
        source_selector = {
          winbar = true;
          statusline = false;
        };
      };

      vim.languages = {
        enableTreesitter = true;
        enableFormat = true;

        # enabling required language support here
        nix.enable = true;
        svelte.enable = true;
        ts.enable = true;
        rust.enable = true;
        python.enable = true;
        bash.enable = true;

        nix.lsp.server = "nixd";
        nix.lsp.options = {
          nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.Andromeda.options";
          home_manager.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.Andromeda.options.home-manager.users.type.getSubOptions []";
          nix-darwin.expr = "(builtins.getFlake (builtins.toString ./.)).darwinConfigurations.Macbook.options";
        };
      };
    };
  };

  home.packages = [pkgs.imagemagick];

  home.sessionVariables.EDITOR = "nvim";
}
