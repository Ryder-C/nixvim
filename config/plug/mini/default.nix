{
  plugins.mini = {
    enable = true;
    mockDevIcons = true;

    modules.statusline = {};
  };

  imports = [
    ./ai.nix
    ./align.nix
    ./animate.nix
    ./clue.nix
    ./cursorword.nix
    ./diff.nix
    ./files.nix
    ./hipatterns.nix
    ./icons.nix
    ./indentscope.nix
    ./notify.nix
    ./pairs.nix
    ./surround.nix
    ./move.nix
    ./pick.nix
  ];
}
