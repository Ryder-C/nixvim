{
  plugins.snacks = {
    enable = true;
    settings = {
      scroll = {
        enabled = true;
      };
    };
  };

  imports = [
    ./dashboard.nix
    ./git.nix
    ./lazygit.nix
    ./notifier.nix
    ./rename.nix
  ];
}
