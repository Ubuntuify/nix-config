{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        enableLuaLoader = true; # enable experimental lua loader

        theme = {
          enable = true;
          name = "rose-pine";
          style = "main";
        };

        # enable plugins -*-
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.blink-cmp.enable = true;

        options = {
          tabstop = 2;
          shiftwidth = 2;
        };

        utility.sleuth.enable = true;
        autopairs.nvim-autopairs.enable = true;
        
        lsp.enable = true;
        languages = {
          enableTreesitter = true;
          enableFormat = true;

          # language support
          nix.enable = true;
          ts.enable = true;
          rust.enable = true;
          python.enable = true;
        };
      };
    };
  };
}
