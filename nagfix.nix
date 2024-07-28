{ config, pkgs, lib, ... }:
{
  # "DRM kernel driver 'nvidia-drm' in use. NVK requires nouveau."
  environment.sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
}