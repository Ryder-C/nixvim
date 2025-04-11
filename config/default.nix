{
  config,
  lib,
  ...
}: {
  imports = [
    ./autocommands.nix
    ./keys.nix
    ./sets.nix
    ./highlight.nix

    ./plug/colorscheme/colorscheme.nix
    ./plug/snippets/luasnip.nix
    ./plug/statusline/lualine.nix

    ./plug/completion
    ./plug/git
    ./plug/lsp
    ./plug/mini
    ./plug/snacks
    ./plug/treesitter
    ./plug/ui
    ./plug/utils
  ];
  options = {
    theme = lib.mkOption {
      default = lib.mkDefault "catppuccin";
      type = lib.types.enum [
        "aquarium"
        "decay"
        "edge-dark"
        "everblush"
        "everforest"
        "far"
        "gruvbox"
        "jellybeans"
        "material"
        "material-darker"
        "mountain"
        "ocean"
        "oxocarbon"
        "paradise"
        "tokyonight"
        "yoru"
        "catppuccin"
      ];
    };
    assistant = lib.mkOption {
      default = "none";
      type = lib.types.enum [
        "copilot"
        "none"
      ];
    };
  };
  config = {
    # The base16 theme to use, if you want to use another theme, change it in colorscheme.nix
    theme = "far";
    extraConfigLua = ''
      _G.theme = "${config.theme}"
    '';
  };
}
