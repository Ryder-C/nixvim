{
  pkgs,
  config,
  ...
}: {
  performance = {
    byteCompileLua = {
      enable = true;
      nvimRuntime = true;
      configs = true;
      plugins = true;
    };
  };
  clipboard = {
    # Use system clipboard
    register = "unnamedplus";

    providers =
      if pkgs.stdenv.isDarwin
      then {}
      else {
        # Wayland clipboard only on non-Darwin systems
        wl-copy = {
          enable = true;
          package = pkgs.wl-clipboard;
        };
      };
  };

  # Over SSH there is no local Wayland display, so wl-clipboard cannot reach the
  # local clipboard. Fall back to OSC 52 (terminal escape sequences) when in an
  # SSH session so yanks to "+"/"*" still land on the local machine's clipboard.
  extraConfigLua = ''
    if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
      local osc52 = require("vim.ui.clipboard.osc52")
      -- Paste reads the unnamed register instead of querying the terminal,
      -- which avoids hangs on terminals that don't answer OSC 52 read requests.
      local function paste()
        return vim.split(vim.fn.getreg(""), "\n")
      end
      vim.g.clipboard = {
        name = "OSC 52",
        copy = {
          ["+"] = osc52.copy("+"),
          ["*"] = osc52.copy("*"),
        },
        paste = {
          ["+"] = paste,
          ["*"] = paste,
        },
      }
    end
  '';

  assertions = [
    # Guardrail: do not enable wl-clipboard on Darwin
    {
      assertion = !pkgs.stdenv.isDarwin || !(config.clipboard.providers."wl-copy".enable or false);
      message = "Darwin builds must not enable wl-clipboard (Wayland). Use pbcopy provider.";
    }
    # Guardrail: ensure wl-clipboard is present for non-Darwin builds
    {
      assertion = pkgs.stdenv.isDarwin || (config.clipboard.providers."wl-copy".enable or false);
      message = "Non-Darwin builds must enable the wl-clipboard provider.";
    }
  ];
  diagnostic.settings = {
    update_in_insert = true;
    severity_sort = true;
    float = {
      border = "rounded";
    };
    jump = {
      severity.__raw = "vim.diagnostic.severity.WARN";
    };
  };
  opts = {
    # Enable relative line numbers
    number = true;
    relativenumber = true;

    # Set tabs to 2 spaces
    tabstop = 2;
    softtabstop = 2;
    showtabline = 0;
    expandtab = true;

    # Enable auto indenting and set it to spaces
    autoindent = true;
    shiftwidth = 2;

    # Enable smart wrapping (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
    breakindent = true;

    # Enable incremental searching
    hlsearch = true;
    incsearch = true;

    # Enable text wrap
    wrap = true;

    # Better splitting
    splitbelow = true;
    splitright = true;

    # Enable mouse mode
    mouse = "a"; # Mouse

    # Enable ignorecase + smartcase for better searching
    ignorecase = true;
    smartcase = true; # Don't ignore case with capitals
    grepprg = "rg --vimgrep";
    grepformat = "%f:%l:%c:%m";

    # Decrease updatetime
    updatetime = 50; # faster completion (4000ms default)

    # Set completeopt to have a better completion experience
    completeopt = [
      "menuone"
      "noselect"
      "noinsert"
    ]; # mostly just for cmp

    # Enable persistent undo history
    swapfile = false;
    autoread = true;
    backup = false;
    undofile = true;

    # Enable 24-bit colors
    termguicolors = true;

    # Enable the sign column to prevent the screen from jumping
    signcolumn = "yes";

    # Enable cursor line highlight
    cursorline = true; # Highlight the line where the cursor is located

    # Set fold settings
    # These options were reccommended by nvim-ufo
    # See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
    foldcolumn = "0";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;

    # Always keep 8 lines above/below cursor unless at start/end of file
    scrolloff = 10;

    # Place a column line
    # colorcolumn = "80";

    # Reduce which-key timeout to 10ms
    timeoutlen = 10;

    # Set encoding type
    encoding = "utf-8";
    fileencoding = "utf-8";

    # More space in the neovim command line for displaying messages
    cmdheight = 0;

    # We don't need to see things like INSERT anymore
    showmode = false;
  };
}
