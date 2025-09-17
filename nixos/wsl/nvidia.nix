{pkgs, ...}: {
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

  nixpkgs.config.cudaSupport = true;
}
