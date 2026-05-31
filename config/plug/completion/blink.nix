{
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        appearance = {
          nerd_font_variant = "mono";
          kind_icons = {
            Copilot = "";
          };
        };

        completion = {
          accept.auto_brackets.enabled = true;
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
            window.border = "rounded";
          };
          menu = {
            border = "rounded";
            draw.treesitter = ["lsp"];
          };
          list.selection = {
            preselect = false;
            auto_insert = true;
          };
          ghost_text.enabled = true;
        };

        signature = {
          enabled = true;
          window.border = "rounded";
        };

        snippets.preset = "luasnip";

        sources = {
          default = ["lsp" "path" "snippets" "buffer" "copilot"];
          per_filetype = {
            gitcommit = ["git" "buffer"];
            markdown = ["lsp" "path" "snippets" "buffer" "spell"];
            tex = ["lsp" "path" "snippets" "buffer" "latex"];
          };
          providers = {
            copilot = {
              name = "copilot";
              module = "blink-cmp-copilot";
              score_offset = 100;
              async = true;
            };
            spell = {
              name = "Spell";
              module = "blink-cmp-spell";
            };
            git = {
              name = "Git";
              module = "blink-cmp-git";
            };
            latex = {
              name = "Latex";
              module = "blink-cmp-latex";
            };
          };
        };

        keymap = {
          preset = "enter";
          "<Tab>" = ["select_next" "fallback"];
          "<S-Tab>" = ["select_prev" "fallback"];
          "<C-d>" = ["scroll_documentation_down" "fallback"];
          "<C-f>" = ["scroll_documentation_up" "fallback"];
          "<C-Space>" = ["show" "show_documentation" "hide_documentation"];
        };
      };
    };

    blink-cmp-copilot.enable = true;
    blink-cmp-git.enable = true;
    blink-cmp-spell.enable = true;
    blink-cmp-latex.enable = true;
  };
}
