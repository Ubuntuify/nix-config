{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sysc-greet.nixosModules.default
  ];

  services.greetd.enable = true;

  services.sysc-greet = {
    enable = true;
    compositor = "niri"; # hardcoded, but should change with different versions
  };
}
