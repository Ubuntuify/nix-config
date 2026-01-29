{
  lib,
  config,
  ...
}: {
  nixpkgs.config.cudaSupport = true; # all packages should be built with cuda support, if on NVIDIA.
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = lib.mkDefault (config.hardware.nvidia.package ? open && config.hardware.nvidia.package ? firmware);
    # a config should override this if using pre-Turing nvidia, as open source (kernel) drivers won't work

    nvidiaSettings = true;
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = lib.mkDefault ["nvidia"];
}
