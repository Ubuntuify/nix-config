{
  description = "Ryan's Home Manager Config (work-in-progress)";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    supportedSystems = ["aarch64-linux" "aarch64-darwin" "x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    # Workaround for no home-manager agnostic configurations, tracked at #3075
    # on its issue tracker. Workaround made by @scottwillmoore on GitHub.
    packages = forEachSupportedSystem ({pkgs}: {
      homeConfigurations.ryans = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [inputs.nvf.homeManagerModules.default ./home.nix ./home/default.nix];
      };
    });

    formatter = forEachSupportedSystem ({pkgs}: pkgs.alejandra);
  };
}
