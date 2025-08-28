{
  pkgs,
  lib,
  ...
}: {
  imports =
    [
      ./ufo.nix
      ./helm.nix
      ./leap.nix
      ./trunk.nix
      ./repeat.nix
      ./sleuth.nix
      ./comment.nix
      ./spectre.nix
      ./markview.nix
      ./presence.nix
      ./undotree.nix
      ./toggleterm.nix
      ./comment-box.nix
      ./typst.nix
    ]
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      ./obsidian.nix
    ];
}
