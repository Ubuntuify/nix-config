{
  self,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
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
      specialArgs = {inherit system inputs outputs username;};
      modules = [
        ../hosts/common/common-packages.nix
        ../hosts/common/darwin-common.nix
        hostSpecificConf
        inputs.home-manager.darwinModules.home-manager
        inputs.mac-app-util.darwinModules.default
        {
          system.primaryUser = username; # explicit workaround: this will be removed in later nix-darwin versions
          networking.hostName = hostname;
          nix.settings.experimental-features = ["nix-command flakes"];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {inherit self inputs outputs;};
          users.users.${username} = {
            # for some reason, home-manager makes an assumption that a user entry always exists here, so we have to define it if we want home-manager to work without erroring out.
            name = username;
            home = "/Users/${username}";
          };
          home-manager.users.${username} = outputs.lib.helpers.mkHome {
            options = {
              user = username;
              system.graphical = lib.mkDefault true;
            };
          };
          home-manager.sharedModules = [
            inputs.mac-app-util.homeManagerModules.default
            {targets.darwin.linkApps.enable = false;} # disables the symlinks made in ~/Applications/Home Manager Apps which don't work for Spotlight anyways
          ]; # makes it so that home-manager apps don't have to use the workaround anymore
          system.configurationRevision = self.rev or "dirty-${self.lastModifiedDate}";
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
  }: let
    hostSpecificConf = builtins.toPath ../hosts/nixos/${hostname}/default.nix; # Since this config is more barren, do not test for if the config exists, it always should.
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit system self inputs outputs;};
      modules = [
        ../hosts/common/common-packages.nix
        ../hosts/common/nixos-common.nix
        inputs.home-manager.nixosModules.default
        hostSpecificConf
        ({
          lib,
          config,
          ...
        }: {
          options.custom = {
            systemUser = lib.mkOption {
              type = lib.types.str;
              default = "user";
            };
          };

          config = {
            custom.systemUser = systemUser;

            users.users.${config.custom.systemUser} = lib.mkDefault {
              isNormalUser = true;
              createHome = true;
              extraGroups = ["wheel"]; # The system user should have access to sudo, or any other elevation program.
            };
          };
        })
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit self inputs outputs;};
          networking.hostName = hostname;
          nix.settings.experimental-features = ["nix-command" "flakes"];
          system.configurationRevision = self.rev or "dirty-${self.lastModifiedDate}";
        } # NixOS configurations are often more varied, so do not define more
      ];
    };

  mkHome = {
    config-name ? "ryans",
    options ? {user = "ryans";},
  }:
    lib.mkMerge [
      ../home/${config-name}/default.nix
      inputs.nvf.homeManagerModules.default
      {home-manager-options = options;} # pass in the options for home-manager as config.home-manager-options
      ({pkgs, ...} @ args: let
        name = options.user or config-name;
      in {
        options.home-manager-options = {
          user = lib.mkOption {
            # user automatically generates the username and home directory according
            # to the defaults of the OS, such as /home/${user} for Linux and /Users/${user}
            # on Darwin/MacOS
            type = lib.types.str;
            description = "User of this home-manager configuration";
          };
        };

        config = {
          home.username = lib.mkForce name;
          # This needs to be set with mkDefault, as the nix-darwin module of home-manager
          # will throw an error otherwise if this is set.
          #
          # It should also be defined as default as anachronistic systems which may not follow
          # the FHS/MacOS standard for home directories may override this setting.
          home.homeDirectory = lib.mkDefault (
            if pkgs.stdenv.hostPlatform.isDarwin
            then "/Users/${name}"
            else "/home/${name}"
          );

          # This option does not exist on darwin systems, therefore should not be set if the
          # host system is not Linux.
          #
          # NixOS setups should setup using the included home-manager NixOS module, so
          # detecting the config attribute passed over should work well enough.
          targets.genericLinux.enable = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) (!builtins.hasAttr "nixosConfig" args);
          programs.home-manager.enable = true;
        };
      })
    ];

  mkDroid = {
    profile ? "full",
    system ? "aarch64-linux",
    username ? "ryans",
    experimental ? {
      enable-lix = lib.mkEnableOption "use the Lix package instead of CppNix";
    },
  }: let
    profileConf = ../hosts/android/${profile}.nix;
    inherit (inputs) nixpkgs;
  in
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          inputs.nix-on-droid.overlays.default
          (lib.composeManyExtensions
            [
              (lib.mkIf experimental.enable-lix outputs.overlays.lix)
            ])
        ];
      };
      extraSpecialArgs = {inherit self inputs outputs;};
      modules = [
        ../hosts/common/android-common.nix
        profileConf
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {inherit self inputs outputs;};
          user.userName = username;
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
        }
      ];
    };
}
