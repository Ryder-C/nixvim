_: let
  get_bufnrs.__raw = ''
    function()
      local buf_size_limit = 1024 * 1024 -- 1MB size limit
      local bufs = vim.api.nvim_list_bufs()
      local valid_bufs = {}
      for _, buf in ipairs(bufs) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf)) < buf_size_limit then
          table.insert(valid_bufs, buf)
        end
      end
      return valid_bufs
    end
  '';
in {
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        mapping = {
          "<C-d>" =
            # Lua
            "cmp.mapping.scroll_docs(-4)";
          "<C-f>" =
            # Lua
            "cmp.mapping.scroll_docs(4)";
          "<C-Space>" =
            # Lua
            "cmp.mapping.complete()";
          "<C-e>" =
            # Lua
            "cmp.mapping.close()";
          "<Tab>" =
            # Lua
            "cmp.mapping(cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
          "<S-Tab>" =
            # Lua
            "cmp.mapping(cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
          "<CR>" =
            # Lua
            "cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })";
        };

        preselect =
          # Lua
          "cmp.PreselectMode.None";

        snippet.expand =
          # Lua
          "function(args) require('luasnip').lsp_expand(args.body) end";

        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
            group_index = 1;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "nvim_lsp_signature_help";
            priority = 1000;
            group_index = 1;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "nvim_lsp_document_symbol";
            priority = 1000;
            group_index = 1;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "copilot";
            priority = 900;
            group_index = 1;
          }
          {
            name = "gitlab";
            priority = 800;
            group_index = 1;
            option = {
              hosts = ["https://gitlab.dnm.radiofrance.fr"];
            };
          }
          {
            name = "treesitter";
            priority = 850;
            group_index = 2;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "luasnip";
            priority = 750;
            group_index = 2;
          }
          {
            name = "buffer";
            priority = 500;
            group_index = 2;
            option = {
              inherit get_bufnrs;
            };
          }
          {
            name = "rg";
            priority = 300;
            group_index = 2;
          }
          {
            name = "path";
            priority = 300;
            group_index = 2;
          }
          {
            name = "cmdline";
            priority = 300;
            group_index = 2;
          }
          {
            name = "spell";
            priority = 300;
            group_index = 2;
          }
          {
            name = "fish";
            priority = 250;
            group_index = 2;
          }
          {
            name = "git";
            priority = 250;
            group_index = 2;
          }
          {
            name = "calc";
            priority = 150;
            group_index = 2;
          }
          {
            name = "emoji";
            priority = 100;
            group_index = 2;
          }
        ];
        sorting = {
          comparators = [
            # Lua
            "require('cmp.config.compare').offset"
            # Lua
            "require('cmp.config.compare').exact"
            # Lua
            "require('cmp.config.compare').score"
            # Lua
            ''
              function(entry1, entry2)
                local types = require('cmp.types')
                local kind1 = entry1:get_kind()
                local kind2 = entry2:get_kind()
                -- Push Snippet and Text to the bottom
                if kind1 == types.lsp.CompletionItemKind.Snippet then kind1 = 100 end
                if kind1 == types.lsp.CompletionItemKind.Text then kind1 = 101 end
                if kind2 == types.lsp.CompletionItemKind.Snippet then kind2 = 100 end
                if kind2 == types.lsp.CompletionItemKind.Text then kind2 = 101 end
                if kind1 ~= kind2 then
                  local diff = kind1 - kind2
                  if diff < 0 then return true
                  elseif diff > 0 then return false
                  end
                end
                return nil
              end
            ''
            # Lua
            "require('cmp.config.compare').recently_used"
            # Lua
            "require('cmp.config.compare').locality"
            # Lua
            "require('cmp.config.compare').length"
            # Lua
            "require('cmp.config.compare').order"
          ];
        };
      };
    };

    cmp-fish.enable = true;
    friendly-snippets.enable = true;
    luasnip.enable = true;

    lspkind = {
      enable = true;
      settings = {
        cmp = {
          enable = true;
          menu = {
            buffer = "";
            calc = "";
            cmdline = "";
            codeium = "󱜙";
            emoji = "󰞅";
            git = "";
            luasnip = "󰩫";
            neorg = "";
            nvim_lsp = "";
            nvim_lua = "";
            path = "";
            spell = "";
            treesitter = "󰔱";
          };
        };
      };
    };
  };
}
