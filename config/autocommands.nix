{
  autoCmd = [
    # Vertically center document when entering insert mode
    {
      event = "InsertEnter";
      command = "norm zz";
    }

    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex"
        "latex"
        "markdown"
        "typst"
        "typ"
      ];
      command = "setlocal spell spelllang=en,fr";
    }
    # Hilight yank text
    {
      event = "TextYankPost";
      pattern = "*";
      command = "lua vim.highlight.on_yank{timeout=500}";
    }
    # Enter git buffer in insert mode
    {
      event = "FileType";
      pattern = [
        "gitcommit"
        "gitrebase"
      ];
      command = "startinsert | 1";
    }
  ];
}
