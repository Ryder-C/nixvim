{pkgs, ...}: {
  extraPackages = with pkgs; [
    prettierd
    prettier
    black
    stylua
    yamlfmt
    hclfmt
  ];

  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        lsp_format = "fallback";
        timeout_ms = 500;
      };
      notify_on_error = true;

      formatters = {
        hclfmt = {
          command = "${pkgs.hclfmt}/bin/hclfmt";
        };
        yamllint = {
          command = "${pkgs.yamllint}/bin/yamllint";
        };
      };

      formatters_by_ft = {
        html = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        css = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        javascript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        javascriptreact = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        typescript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        typescriptreact = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        python = ["black"];
        lua = ["stylua"];
        nix = ["alejandra"];
        markdown = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        mdx = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          stop_after_first = true;
        };
        yaml = [
          "yamllint"
          "yamlfmt"
        ];
        terragrunt = [
          "hclfmt"
        ];
        rust = ["rustfmt"];

        typst = ["typstyle"];
      };
    };
  };
}
