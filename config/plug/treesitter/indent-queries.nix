{
  # Upstream nvim-treesitter's nix/indents.scm has no rules for (formals) outside
  # of ERROR nodes, so a multi-line function argument list never opens or closes
  # an indent level of its own. Inside a binding this leaks the binding's level
  # past the closing "}", putting the whole function body one level too far in:
  #
  #   ry.packages.homeManager = {
  #     pkgs,
  #     ...
  #   }: let
  #       zink-env = [   <- one level too deep, and so is everything after it
  #
  # At the top level the opposite happens and the formals get no indent at all.
  #
  # Give (formals) its own begin/end, then cancel the binding's now-duplicate
  # level for the function body. The dedent is limited to multi-line formals
  # because alejandra keeps `a = {pkgs, ...}: {` on one line at a single level.
  extraFiles."after/queries/nix/indents.scm".text = ''
    ; extends
    (formals) @indent.begin

    (formals
      "}" @indent.branch @indent.end)

    ((function_expression
      formals: (formals) @_formals
      body: (_) @indent.dedent) @_fn
      (#has-parent? @_fn binding)
      (#lua-match? @_formals "\n"))
  '';
}
