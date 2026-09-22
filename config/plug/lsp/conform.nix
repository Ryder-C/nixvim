{pkgs, ...}: {
  extraPackages = with pkgs; [
    alejandra
    prettierd
    prettier
    black
    stylua
    yamlfmt
    hclfmt
    typstyle
    # clangd already puts clang-tools on $PATH, but conform should not depend
    # on the LSP being enabled for its formatter to resolve.
    clang-tools
    gersemi
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

        # clang-format picks up the project's .clang-format; the
        # --fallback-style passed to clangd only applies when there isn't one.
        c = ["clang-format"];
        cpp = ["clang-format"];
        objc = ["clang-format"];
        objcpp = ["clang-format"];
        cuda = ["clang-format"];
        proto = ["clang-format"];

        cmake = ["gersemi"];

        typst = ["typstyle"];
      };
    };
  };
}
