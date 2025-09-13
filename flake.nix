{
  description = "Ryan's Nix configuration flake";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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
    specialArgs = {inherit inputs;};
  in {
    # Workaround for no home-manager agnostic configurations, tracked at #3075
    # on its issue tracker. Workaround made by @scottwillmoore on GitHub.
    packages = forEachSupportedSystem ({pkgs}: {
      homeConfigurations.ryans = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [inputs.nvf.homeManagerModules.default ./home.nix ./home/default.nix];
        extraSpecialArgs = specialArgs;
      };
    });

    nixosConfigurations.Afina = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
    };

    nixosConfigurations.Andromeda = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = [
        ./nix/system/andromeda.nix
        home-manager.nixosModules.home-manager
        inputs.nixos-wsl.nixosModules.default
        {home-manager.extraSpecialArgs = specialArgs;}
      ];
    };

    nixosConfigurations.Cassiopeia = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
    };

    nixosConfigurations.Persephone =
      nixpkgs.lib.nixosSystem {
      };

    nixosConfigurations.Melinoe = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
    };

    formatter = forEachSupportedSystem ({pkgs}: pkgs.alejandra);
  };
}
