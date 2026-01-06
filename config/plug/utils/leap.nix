{
  plugins.leap.enable = true;
  plugins.flit.enable = true;

  keymaps = [
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "s";
      action = "<Plug>(leap-forward)";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "S";
      action = "<Plug>(leap-backward)";
    }
  ];
}
