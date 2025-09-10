{pkgs, ...}: {
  plugins.toggleterm = {
    enable = true;
    settings = {
      open_mapping = "[[<C-/>]]";
      shell = "${pkgs.nushell}/bin/nu";
    };
  };
}
