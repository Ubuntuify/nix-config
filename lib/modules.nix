{
  inputs,
  outputs,
  ...
}: let
  inherit (outputs) lib;
in {
  # Creates a way to easily create system-agnostic (between Darwin/MacOS and NixOS) system modules. Modules
  # will error out under lib.mkIf, even if an instance of something does not exist on that system. For example
  # using anything under hardware in a nix-darwin system.
  mkMultiSystemModule = {
    pkgs,
    options,
    systemAgnosticModule ? {}, # nix-darwin and NixOS are similar in some natures, so much that home-manager uses a lot
    # of shared code for both nix-darwin and NixOS. This allows shared code to be provided.
    nixosModule ? {}, # gracefully fail if there's nothing there
    darwinModule ? {},
  }: let
    inherit (pkgs.stdenv) hostPlatform;
  in
    inputs.nixpkgs.lib.mkMerge [
      systemAgnosticModule
      # mkIf however has the power of lazily evaluating, allowing more power, for example evaluating hostPlaform.
      (inputs.nixpkgs.lib.mkIf hostPlatform.isLinux (
        # The following code hides it from Nix when checking, only making sure that it sees it on the respective system
        # making sure that it won't error. "config.hardware" only exists on NixOS, therefore it will only show the NixOS
        # module on NixOS systems, causing no error.
        if (builtins.hasAttr "hardware" options)
        then nixosModule
        else {}
      ))
      (inputs.nixpkgs.lib.mkIf hostPlatform.isDarwin (
        # The same is done here. Launchd is the equivalent of the daemon service on MacOS/Darwin, and only exists on MacOS
        # systems, so does homebrew configuration. This allows you to configure those options without causing an error.
        if (builtins.hasAttr "launchd" options)
        then darwinModule
        else {}
      ))
    ];

  # This simply uses the mkMultiSystemModule function to make sure that modules are not imported in the wrong way.
  # I probably won't use this until the codebase gets larger.
  mkNixosModule = {
    pkgs,
    options,
    module,
  }:
    lib.mkMultiSystemModule {
      inherit pkgs options;
      nixosModule = module;
      darwinModule = builtins.throw "Darwin configuration is importing a NixOS only module, this is not supported and is a no-op.";
    };

  mkDarwinModule = {
    pkgs,
    options,
    module,
  }:
    lib.mkMultiSystemModule {
      inherit pkgs options;
      nixosModule = builtins.throw "NixOS configuration is importing a nix-darwin only module, this is not supported and is a no-op.";
      darwinModule = module;
    };
}
