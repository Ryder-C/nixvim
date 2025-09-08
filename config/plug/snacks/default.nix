{
  plugins.snacks = {
    enable = true;
    settings = {
      scroll = {
        enabled = false;
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
