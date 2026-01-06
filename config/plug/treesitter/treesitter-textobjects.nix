{ pkgs, ... }:
{
  plugins.treesitter-textobjects = {
    enable = true;
    package = pkgs.vimPlugins.nvim-treesitter-textobjects.overrideAttrs (_old: {
      doCheck = false;
      doInstallCheck = false;
      nvimRequireCheck = null;
    });
    settings = {
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "aa" = "@parameter.outer";
          "ia" = "@parameter.inner";
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = "@class.inner";
          "ii" = "@conditional.inner";
          "ai" = "@conditional.outer";
          "il" = "@loop.inner";
          "al" = "@loop.outer";
          "at" = "@comment.outer";
        };
      };
      move = {
        enable = true;
        goto_next_start = {
          "]m" = "@function.outer";
          "]]" = "@class.outer";
        };
        goto_next_end = {
          "]M" = "@function.outer";
          "][" = "@class.outer";
        };
        goto_previous_start = {
          "[m" = "@function.outer";
          "[[" = "@class.outer";
        };
        goto_previous_end = {
          "[M" = "@function.outer";
          "[]" = "@class.outer";
        };
      };
      swap = {
        enable = true;
        swap_next = {
          "<leader>a" = "@parameters.inner";
        };
        swap_previous = {
          "<leader>A" = "@parameter.outer";
        };
      };
      lsp_interop = {
        enable = true;
        border = "single";
        peek_definition_code = {
          "<leader>df" = {
            query = "@function.outer";
            desc = "Peek definition outer function";
          };
          "<leader>dF" = {
            query = "@class.outer";
            desc = "Peek definition outer class";
          };
        };
      };
    };
  };
}
