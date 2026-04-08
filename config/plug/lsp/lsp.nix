{
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        html = {
          enable = true;
        };
        astro = {
          enable = true;
        };
        lua_ls = {
          enable = true;
        };
        nixd = {
          enable = true;
          extraOptions = {
            nixos = {
              expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.aurelionite.options";
            };
            home_manager = {
              expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.aurelionite.options";
            };
          };
        };
        markdown_oxide = {
          enable = true;
        };
        ruff = {
          enable = true;
        };
        gopls = {
          enable = true;
        };
        terraformls = {
          enable = true;
        };
        yamlls = {
          enable = true;
        };
        tinymist = {
          enable = true;
          settings = {
            exportPdf = "onType";
            # outputPath = "$root/out/$name";
          };
        };
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        clangd = {
          enable = true;
        };
      };
      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          # Use LSP saga keybinding instead
          # K = {
          #   action = "hover";
          #   desc = "Hover";
          # };
          # "<leader>cw" = {
          #   action = "workspace_symbol";
          #   desc = "Workspace Symbol";
          # };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
        };
        # diagnostic = {
        #   "<leader>cd" = {
        #     action = "open_float";
        #     desc = "Line Diagnostics";
        #   };
        #   "[d" = {
        #     action = "goto_next";
        #     desc = "Next Diagnostic";
        #   };
        #   "]d" = {
        #     action = "goto_prev";
        #     desc = "Previous Diagnostic";
        #   };
        # };
      };
    };
    typescript-tools = {
      enable = true;
      settings = {
        on_attach = ''
          function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        '';
        settings = {
          expose_as_code_action = "all";
          tsserver_format_options = {};
        };
      };
    };
  };
  extraConfigLua = ''
    local _border = "rounded"

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = _border
      }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = _border
      }
    )

    vim.diagnostic.config{
      float={border=_border}
    };

    require('lspconfig.ui.windows').default_options = {
      border = _border
    }
  '';
}
