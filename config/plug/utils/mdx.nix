{
  pkgs,
  inputs,
  ...
}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "mdx.nvim";
      version = "2026-03-29";
      src = inputs.mdx-nvim;
    })
  ];

  extraConfigLua = ''
    require("mdx").setup()
  '';
}
