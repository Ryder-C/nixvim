{pkgs, ...}: {
  plugins = {
    vimtex = {
      enable = true;
      # zathura doesn't build cleanly on darwin (appstream dep), use Skim there
      zathuraPackage =
        if pkgs.stdenv.isDarwin
        then null
        else pkgs.zathura;
      mupdfPackage =
        if pkgs.stdenv.isDarwin
        then null
        else pkgs.mupdf;
      settings = {
        view_method =
          if pkgs.stdenv.isDarwin
          then "skim"
          else "zathura";
        compiler_method = "latexmk";
        fold_enabled = 1;
      };
    };

    # cmp-vimtex: completion source for nvim-cmp (active completion engine)
    cmp-vimtex.enable = true;

    # blink-cmp-latex: completion source for blink-cmp (ready if switched)
    blink-cmp-latex.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>l";
      action = "+latex";
      options.desc = "+latex";
    }
    {
      mode = "n";
      key = "<leader>ll";
      action = "<cmd>VimtexCompile<cr>";
      options = {
        silent = true;
        desc = "Compile (toggle)";
      };
    }
    {
      mode = "n";
      key = "<leader>lv";
      action = "<cmd>VimtexView<cr>";
      options = {
        silent = true;
        desc = "View PDF";
      };
    }
    {
      mode = "n";
      key = "<leader>lk";
      action = "<cmd>VimtexStop<cr>";
      options = {
        silent = true;
        desc = "Stop compilation";
      };
    }
    {
      mode = "n";
      key = "<leader>lK";
      action = "<cmd>VimtexStopAll<cr>";
      options = {
        silent = true;
        desc = "Stop all compilations";
      };
    }
    {
      mode = "n";
      key = "<leader>le";
      action = "<cmd>VimtexErrors<cr>";
      options = {
        silent = true;
        desc = "Show errors";
      };
    }
    {
      mode = "n";
      key = "<leader>lt";
      action = "<cmd>VimtexTocToggle<cr>";
      options = {
        silent = true;
        desc = "Toggle table of contents";
      };
    }
    {
      mode = "n";
      key = "<leader>lc";
      action = "<cmd>VimtexClean<cr>";
      options = {
        silent = true;
        desc = "Clean auxiliary files";
      };
    }
    {
      mode = "n";
      key = "<leader>lC";
      action = "<cmd>VimtexClean!<cr>";
      options = {
        silent = true;
        desc = "Clean all (including PDF)";
      };
    }
    {
      mode = "n";
      key = "<leader>li";
      action = "<cmd>VimtexInfo<cr>";
      options = {
        silent = true;
        desc = "Project info";
      };
    }
  ];
}
