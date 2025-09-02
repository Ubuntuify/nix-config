{
  description = "Ryan's Home Manager Config (work-in-progress)";

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

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nvf,
      ...
    }:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        asahi = nixpkgs.lib.nixosSystem {

        };
      };

      homeConfigurations = {
        ryans = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            nvf.homeManagerModules.default
            ./home.nix
          ];
        };
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
