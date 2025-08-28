{
  pkgs,
  lib,
  ...
}:
lib.mkIf (!pkgs.stdenv.isDarwin) {
  plugins.obsidian = {
    enable = true;
    settings = {
      legacy_commands = false;
      completion = {
        min_chars = 2;
        nvim_cmp = false;
      };
      new_notes_location = "current_dir";
      workspaces = [
        {
          name = "default";
          path = "~/Documents";
        }
      ];
    };
  };
  keymaps = [
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "gf";
      action.__raw = "function() return require('obsidian').util.gf_passthrough() end";
      options = {
        noremap = false;
        expr = true;
        buffer = true;
        desc = "Obsidian follow link (fallback to built-in gf)";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ch";
      action.__raw = "function() return require('obsidian').util.toggle_checkbox() end";
      options = {
        buffer = true;
        desc = "Obsidian toggle checkbox";
      };
    }
  ];
}
