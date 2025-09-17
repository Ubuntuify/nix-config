{
  description = "Ryan's Nix configuration flake";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    apple-silicon.url = "github:nix-community/nixos-apple-silicon/main";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nix-darwin,
    home-manager,
    ...
  }: let
    supportedSystems = ["aarch64-linux" "aarch64-darwin" "x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            config = {allowUnfree = true;};
          };
        });
    mkHomeModules = options: [
      inputs.nvf.homeManagerModules.default
      ./home/default.nix
      {hm-options = options;}
    ];
    specialArgs = {
      inherit inputs;
      inherit mkHomeModules;
    };
  in {
    # Workaround for no home-manager agnostic configurations, tracked at #3075
    # on its issue tracker. Workaround made by @scottwillmoore on GitHub.
    packages = forEachSupportedSystem ({pkgs}: {
      homeConfigurations.ryans = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = mkHomeModules {
          user = "ryans";
          system.graphical = true;
        };
        extraSpecialArgs = specialArgs;
      };
    });

    nixosConfigurations = {
      Afina = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
      };

      Andromeda = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          ./nixos/system/andromeda.nix
          home-manager.nixosModules.home-manager
          inputs.nixos-wsl.nixosModules.default
          {home-manager.extraSpecialArgs = specialArgs;}
        ];
      };

      Cassiopeia = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "aarch64-linux";
        modules = [inputs.nixos-wsl.nixosModules.default];
      };

      Persephone = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
      };

      Melinoe = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "aarch64-linux";
        modules = [inputs.apple-silicon.nixosModules.apple-silicon-support];
      };
    };

    darwinConfigurations.Macbook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin/profile/Macbook.nix
        home-manager.darwinModules.home-manager
        {home-manager.extraSpecialArgs = specialArgs;}
      ];
    };

    formatter = forEachSupportedSystem ({pkgs}: pkgs.alejandra);
  };
}
