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
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    inherit (self) outputs;
    libx = import ./lib {inherit inputs outputs;};
  in {
    nixosConfigurations = {
      #Afina = libx.mkNixos {hostname = "Afina";};
      Andromeda = libx.mkNixos {
        hostname = "Andromeda";
        supportModules = [inputs.nixos-wsl.nixosModules.default];
      };
      #Cassiopeia = libx.mkNixos {
      #  hostname = "Cassiopeia";
      #  system = "aarch64-linux";
      #  supportModules = [inputs.nixos-wsl.nixosModules.default];
      #};
      #Persephone = libx.mkNixos {hostname = "Persephone";};
      #Melinoe = libx.mkNixos {hostname = "Melinoe";};
      Thanatos = libx.mkNixos {
        hostname = "Thanatos";
        system = "aarch64-linux";
        supportModules = [inputs.apple-silicon.nixosModules.apple-silicon-support];
      };
    };

    darwinConfigurations = {
      Pomegranate = libx.mkDarwin {hostname = "Pomegranate";};
    };

    formatter = libx.forEachSupportedSystem ({pkgs}: pkgs.alejandra);
  };
}
