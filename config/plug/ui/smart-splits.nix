{
  plugins.smart-splits.enable = true;
  keymaps = [
    {
      mode = "n";
      key = "<C-n>";
      action = ":lua require('smart-splits').move_cursor_left()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<C-e>";
      action = ":lua require('smart-splits').move_cursor_down()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<C-i>";
      action = ":lua require('smart-splits').move_cursor_up()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<C-o>";
      action = ":lua require('smart-splits').move_cursor_right()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<A-n>";
      action = ":lua require('smart-splits').resize_left()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<A-e>";
      action = ":lua require('smart-splits').resize_down()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<A-i>";
      action = ":lua require('smart-splits').resize_up()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<A-o>";
      action = ":lua require('smart-splits').resize_right()<CR>";
      options.silent = true;
    }
  ];
}
