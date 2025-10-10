{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  isWSL = builtins.hasAttr "wsl" config;
in
  mkMerge [
    {nixpkgs.config.cudaSupport = true;} # all packages should be built with cuda support, if on NVIDIA.
    (mkIf (!isWSL) {
      # Bare metal settings

      # These are the normal settings you would enter if you were running on bare metal,
      # or doing virtual machine GPU pass through.

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        open = mkDefault (config.hardware.nvidia.package ? open && config.hardware.nvidia.package ? firmware); # a config should override this if using pre-Turing nvidia, as open source (kernel) drivers won't work
        nvidiaSettings = true;
      };

      hardware.graphics.enable = true;
      services.xserver.videoDrivers = mkDefault ["nvidia"];
    })
    (mkIf isWSL {
      # NixOS-WSL specific settings

      # These settings are specific to when only a D3D12 driver is exposed to the Linux kernel,
      # and since it is running in a VM, gaming is not often a priority.
      # CUDA support, and other NVIDIA toolkits are engaged here.

      hardware.nvidia-container-toolkit = {
        enable = true;
        mount-nvidia-executables = false;
        mount-nvidia-docker-1-directories = true;
        suppressNvidiaDriverAssertion = true;
      };

      # Creates a LD_LIBRARY_PATH to required libraries, i.e. for running foreign libraries that
      # require CUDA.

      programs.nix-ld = let
        wsl-lib = pkgs.runCommand "wsl-lib" {} ''
          mkdir -p "$out/lib"
          ln -s /usr/lib/wsl/lib/libcudadebugger.so.1 "$out/lib"
          ln -s /usr/lib/wsl/lib/libcuda.so "$out/lib"
          ln -s /usr/lib/wsl/lib/libcuda.so.1 "$out/lib"
          ln -s /usr/lib/wsl/lib/libcuda.so.1.1 "$out/lib"
          ln -s /usr/lib/wsl/lib/libd3d12core.so "$out/lib"
          ln -s /usr/lib/wsl/lib/libd3d12.so "$out/lib"
          ln -s /usr/lib/wsl/lib/libdxcore.so "$out/lib"
          ln -s /usr/lib/wsl/lib/libnvcuvid.so "$out/lib"
          ln -s /usr/lib/wsl/lib/libnvcuvid.so.1 "$out/lib"
          ln -s /usr/lib/wsl/lib/libnvdxdlkernels.so "$out/lib"
          ln -s /usr/lib/wsl/lib/libnvidia-encode.so "$out/lib"
          ln -s /usr/lib/wsl/lib/libnvidia-encode.so.1 "$out/lib"
          ln -s /usr/lib/wsl/lib/libnvidia-ml.so.1 "$out/lib"
          ln -s /usr/lib/wsl/lib/libnvidia-opticalflow.so "$out/lib"
          ln -s /usr/lib/wsl/lib/libnvidia-opticalflow.so.1 "$out/lib"
          ln -s /usr/lib/wsl/lib/libnvoptix.so.1 "$out/lib"
          ln -s /usr/lib/wsl/lib/libnvwgf2umx.so "$out/lib"
          ln -s /usr/lib/wsl/lib/nvidia-smi "$out/lib"
        '';
      in {
        enable = true;
        libraries = [wsl-lib];
      };
    })
  ]
