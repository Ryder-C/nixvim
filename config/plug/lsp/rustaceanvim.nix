{pkgs, ...}: let
  codelldb = pkgs.vscode-extensions.vadimcn.vscode-lldb;
  codelldbPath = "${codelldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
  liblldbExt =
    if pkgs.stdenv.isDarwin
    then "dylib"
    else "so";
  liblldbPath = "${codelldb}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.${liblldbExt}";
in {
  extraPackages = [pkgs.rust-analyzer];

  plugins.rustaceanvim = {
    enable = true;
    settings = {
      server = {
        default_settings = {
          rust-analyzer = {
            check.command = "clippy";
            inlayHints.lifetimeElisionHints.enable = "skip_trivial";
          };
        };
      };
      dap = {
        adapter.__raw = ''
          require("rustaceanvim.config").get_codelldb_adapter(
            "${codelldbPath}",
            "${liblldbPath}"
          )
        '';
      };
    };
  };
}
