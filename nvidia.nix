{
  config,
  pkgs,
  lib,
  ...
}:
{
  hardware = {
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = true;
      # ensures all GPUs stay awake during headless mode
      nvidiaPersistenced = true;
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = true;
      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  environment = {
    # FIXES: "DRM kernel driver 'nvidia-drm' in use. NVK requires nouveau."
    sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };
  
  nixpkgs.config = {
    # see https://en.wikipedia.org/wiki/CUDA#GPUs_supported for RTX 3080
    cudaCapabilities = [ "8.6" ];
    # cudaForwardCompat = true; # see if this even does anything
  };
}
