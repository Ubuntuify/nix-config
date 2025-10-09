{
  description = "Ryan's Nix configuration flake";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  inputs = {
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
    libx = import ./lib {inherit self inputs outputs;};
  in {
    # <prerequisite/required>
    # These are parts that are taken out for modules to work, they are necessary for some parts
    # of the flake to function properly and removing them should be taken care of carefully, by
    # checking if any part requires anything defined here.

    overlays = inputs.haumae.lib.load {
      src = ./overlays;
      inputs = {inherit inputs;};
    };

    modules = inputs.haumae.lib.load {
      src = ./modules;
      loader = inputs.haumae.lib.loaders.verbatim;
    };

    # <system/configurations>
    # This flake is, of course, a configuration flake for NixOS, nix-darwin, and nix-on-droid.
    # This is where systems are defined, and, if required, their support modules, showing what
    # kind of system they are.

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
      #Thanatos = libx.mkNixos {
      #  hostname = "Thanatos";
      #  system = "aarch64-linux";
      #  supportModules = [inputs.apple-silicon.nixosModules.apple-silicon-support];
      #};
    };

    darwinConfigurations = {
      Pomegranate = libx.mkDarwin {hostname = "Pomegranate";};
    };

    nixOnDroidConfigurations = {
      default = libx.mkDroid {
        profile = "go";
        experimental.enable-lix = true;
      };
    };

    # <extra/misc>
    # These are development requirements or miscellaneous configurations that are not required
    # for the flake. Anything defined below can be removed with little to no issue.

    formatter = libx.forEachSupportedSystem ({pkgs}: pkgs.alejandra);
  };
}
