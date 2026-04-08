_: {
  plugins.none-ls = {
    enable = true;
    enableLspFormat = false;
    settings = {
      updateInInsert = false;
    };
    sources = {
      code_actions = {
        # gitsigns.enable = true;
        statix.enable = true;
      };
      diagnostics = {
        statix.enable = true;
        yamllint.enable = true;
      };
      formatting = {
        alejandra.enable = false;
        black.enable = false;
        prettier.enable = false;
        stylua.enable = false;
        yamlfmt.enable = false;
        hclfmt.enable = false;
        typstyle.enable = false;
      };
    };
  };
  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cf";
      action = "<cmd>lua vim.lsp.buf.format()<cr>";
      options = {
        silent = true;
        desc = "Format";
      };
    }
  ];
}
