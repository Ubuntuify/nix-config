{
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  libx = import ./default.nix {inherit inputs outputs;};
  supportedSystems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];
in {
  forEachSupportedSystem = f:
    lib.genAttrs supportedSystems (system:
      f {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      });

  mkDarwin = {
    hostname,
    username ? "ryan",
    system ? "aarch64-darwin",
  }: let
    hostSpecificConfPath = builtins.toString ../hosts/darwin/${hostname};
    hostSpecificConf =
      if builtins.pathExists hostSpecificConfPath
      then (hostSpecificConfPath + "/default.nix")
      else ../hosts/common/darwin-common-dock.nix;
  in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit system inputs username;};
      modules = [
        ../hosts/common/common-packages.nix
        ../hosts/common/darwin-common.nix
        hostSpecificConf
        inputs.home-manager.darwinModules.home-manager
        {
          system.primaryUser = username; # explicit workaround: this will be removed in later nix-darwin versions
          networking.hostName = hostname;
          system.stateVersion = 6;
          nix.settings.experimental-features = ["nix-command flakes"];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {inherit inputs outputs;};
          users.users.${username} = {
            # for some reason, home-manager makes an assumption that a user entry always exists here, so we have to define it if we want home-manager to work without erroring out.
            name = username;
            home = "/Users/${username}";
          };
          home-manager.users.${username} = libx.mkHome {
            options = {
              user = username;
              system.graphical = lib.mkDefault true;
            };
          };
        }
        inputs.nix-homebrew.darwinModules.nix-homebrew
        ({config, ...}: {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            autoMigrate = true;
            user = username;
          };
          homebrew.user = config.nix-homebrew.user;
        })
      ];
    };

  mkNixos = {
    hostname,
    systemUser ? "ryans", # managing user/main admin account
    system ? "x86_64-linux",
    supportModules, # for systems that need extra support modules, such as NixOS-WSL and Apple Silicon
  }: let
    hostSpecificConf = "./../hosts/nixos/${hostname}/default.nix"; # Since this config is more barren, do not test for if the config exists, it always should.
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit system inputs libx systemUser;}; # pass in the mkHome helper function, so the NixOS config can make users and home-manager configurations at will.
      modules = lib.mkMerge [
        [
          ../hosts/common/common-packages.nix
          inputs.home-manager.nixosModules.default
          hostSpecificConf
          {
            networking.hostName = hostname;
            nix.settings.experimental-features = ["nix-command" "flakes"];
            system.stateVersion = "25.05"; # set stateVersion here, and not in the individual configs themselves
          } # NixOS configurations are often more varied, so do not define more
        ]
        supportModules
      ];
    };

  mkHome = {
    config-name ? "ryans",
    options,
  }: let
  in
    lib.mkMerge [
      ../home/${config-name}/default.nix
      inputs.nvf.homeManagerModules.default
      {home-manager-options = options;} # pass in the options for home-manager as config.home-manager-options
    ];
}
