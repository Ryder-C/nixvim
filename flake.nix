{
  description = "Ryder's NeoVim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixvim,
    flake-parts,
    pre-commit-hooks,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem = {
        system,
        pkgs,
        self',
        ...
      }: let
        nixvim' = nixvim.legacyPackages.${system};
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = ./config;
        };
      in {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              statix.enable = true;
              deadnix = {
                enable = true;
                settings = {
                  edit = true;
                };
              };
            };
          };
        };

        # formatter = pkgs.nixfmt-rfc-style;

        packages = {
          default = nvim;

          # linters
          linters = with pkgs; [yamllint];

          formatters = with pkgs; [
            rustfmt
            prettierd
            typstyle
            stylua
            alejandra
            black
            yamlfmt
            hclfmt
          ];
        };

        devShells = {
          default = with pkgs;
            mkShell {
              # Concatenate the lists of linters and formatters.
              buildInputs = self.packages.linters ++ self.packages.formatters;

              # Inherit the pre-commit hook's shellHook to run any startup commands.
              inherit (self'.checks.pre-commit-check) shellHook;
            };
        };
      };
    };
}
