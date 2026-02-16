{ pkgs, ... }:
{
  filetype.extension = {
    liq = "liquidsoap";
    typ = "typst";
  };

  plugins.treesitter = {
    enable = true;

    settings = {
      indent = {
        enable = true;
      };
      highlight = {
        enable = true;
      };
    };

    folding.enable = true;
    languageRegister.liq = "liquidsoap";
    nixvimInjections = true;
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
  };

}
