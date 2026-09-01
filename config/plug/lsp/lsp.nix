{
  pkgs,
  lib,
  ...
}: let
  # Candidate locations for the system flake, first match wins.
  systemFlakePaths = [
    "/home/ryder/nixos-config"
    "/etc/nixos-config"
  ];
  thisFlake = "/home/ryder/Code/nixvim";

  # nixd evaluates these strings itself, so both the flake location and the host
  # are resolved at LSP runtime rather than baked into a config shared by all
  # four machines (and built on only one of them).
  systemFlake = ''
    (let
      found = builtins.filter (p: builtins.pathExists (p + "/flake.nix")) [${lib.concatMapStringsSep " " (p: "\"${p}\"") systemFlakePaths}];
    in
      if found == []
      then throw "nixd: no system flake at any of ${lib.concatStringsSep ", " systemFlakePaths}"
      else builtins.getFlake (builtins.head found))'';

  nixosOptions = ''${systemFlake}.nixosConfigurations.''${builtins.replaceStrings ["\n"] [""] (builtins.readFile /etc/hostname)}.options'';
in {
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        html = {
          enable = true;
        };
        mdx_analyzer = {
          enable = true;
          package = pkgs.mdx-language-server;
        };
        astro = {
          enable = true;
        };
        lua_ls = {
          enable = true;
        };
        # Runs alongside nixd: nil contributes static lints (unused bindings,
        # redundant `with`), nixd contributes evaluation-based errors and
        # option/package completion. Formatting is left to conform's alejandra.
        nil_ls = {
          enable = true;
          onAttach.function = ''
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          '';
        };
        nixd = {
          enable = true;
          settings = {
            # Without this nixd cannot complete or document `pkgs.*` at all.
            # Reuse the system flake's nixpkgs so this costs no extra closure.
            nixpkgs.expr = ''import ${systemFlake}.inputs.nixpkgs {}'';

            formatting.command = [(lib.getExe pkgs.alejandra)];

            options = {
              nixos.expr = nixosOptions;

              # home-manager is a NixOS module here, not a standalone
              # homeConfigurations output.
              home-manager.expr = "${nixosOptions}.home-manager.users.type.getSubOptions []";

              # Options for this repo itself, so editing the nixvim config gets
              # completion for `plugins.*`, `keymaps.*`, etc.
              nixvim.expr = ''((builtins.getFlake "${thisFlake}").inputs.nixvim.legacyPackages.''${builtins.currentSystem}.makeNixvimWithModule {module = {};}).options'';
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

    local _orig_hover = vim.lsp.buf.hover
    vim.lsp.buf.hover = function(opts)
      opts = opts or {}
      opts.border = opts.border or _border
      return _orig_hover(opts)
    end

    local _orig_signature_help = vim.lsp.buf.signature_help
    vim.lsp.buf.signature_help = function(opts)
      opts = opts or {}
      opts.border = opts.border or _border
      return _orig_signature_help(opts)
    end

    vim.diagnostic.config{
      float={border=_border},
      virtual_text=true,
    };

    require('lspconfig.ui.windows').default_options = {
      border = _border
    }
  '';
}
