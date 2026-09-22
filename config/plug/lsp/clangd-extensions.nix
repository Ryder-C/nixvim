_: {
  plugins.clangd-extensions = {
    enable = true;

    # Left off deliberately: forcing utf-16 costs clangd its native utf-8
    # encoding, and nothing else attaches to C/C++ buffers here (none-ls only
    # has nix and yaml sources). Turn this on if a second client ever does and
    # neovim starts warning about mixed offset encodings.
    enableOffsetEncodingWorkaround = false;

    settings = {
      memory_usage.border = "rounded";
      symbol_info.border = "rounded";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ch";
      action = "<cmd>ClangdSwitchSourceHeader<cr>";
      options = {
        silent = true;
        desc = "C++: Switch Source/Header";
      };
    }
    {
      mode = "n";
      key = "<leader>ct";
      action = "<cmd>ClangdTypeHierarchy<cr>";
      options = {
        silent = true;
        desc = "C++: Type Hierarchy";
      };
    }
    {
      mode = "n";
      key = "<leader>cA";
      action = "<cmd>ClangdAST<cr>";
      options = {
        silent = true;
        desc = "C++: AST";
      };
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>ClangdSymbolInfo<cr>";
      options = {
        silent = true;
        desc = "C++: Symbol Info";
      };
    }
    {
      mode = "n";
      key = "<leader>cm";
      action = "<cmd>ClangdMemoryUsage<cr>";
      options = {
        silent = true;
        desc = "C++: clangd Memory Usage";
      };
    }
  ];
}
