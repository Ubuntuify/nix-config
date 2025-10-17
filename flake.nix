{
  description = "Ryan's Nix configuration flake";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org" "https://nixos-apple-silicon.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="];
  };

  inputs = {
    self.submodules = true; # enable submodules support

    # Main system components (i.e. NixOS, nix-darwin, etc.)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs"; # These stop nix from downloading multiple instances of nixpkgs
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager"; # nix-on-droid implements its own home-manager plugin, and
      # may not have the updates that home-manager currently has, lock it to prevent issues with current.
    };

    # Secrets manager
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User components (such as for: setting up home directories, and homebrew)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Support modules (modules that connect to main system components to add patches for NixOS to work)
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Alternate repositories
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake components
    haumae = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    inherit (self) outputs;
    systems = import ./systems.nix {inherit inputs outputs;};
  in {
    overlays = inputs.haumae.lib.load {
      src = ./overlays;
      inputs = {inherit inputs;};
    };
    lib = import ./lib {inherit self inputs outputs;};
    inherit (systems) nixosConfigurations darwinConfigurations;
    formatter = outputs.lib.forEachSupportedSystem ({pkgs}: pkgs.alejandra);
  };
}
