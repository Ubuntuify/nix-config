{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkMerge [
  {nixpkgs.config.cudaSupport = true;} # all packages should be built with cuda support, if on NVIDIA.
  (
    if (!config.wsl.enable)
    then {
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        open = lib.mkDefault true; # a config should override this if using pre-Turing nvidia, as open source (kernel) drivers won't work
        nvidiaSettings = true;
      };
    }
    else {
      # WSL specific settings
      hardware.nvidia-container-toolkit = {
        enable = true;
        mount-nvidia-executables = false;
        mount-nvidia-docker-1-directories = true;
        suppressNvidiaDriverAssertion = true;
      };

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

      # A hook to export variables for CUDA support on NixOS-WSL.
      shellHook = ''
        export CUDA_PATH=${pkgs.cudatoolkit}
        export LD_LIBRARY_PATH=/usr/lib/wsl/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib
        export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
        export EXTRA_CCFLAGS="-I/usr/include"
      '';
    }
  )
]
