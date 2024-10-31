{ config, pkgs, lib, ... }:
{
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
        # declare allowed unfree packages here
        "nvidia-x11"
        "nvidia-persistenced"
        "nvidia-settings"
        "cuda_cudart"
        "cuda_nvcc"
        "cuda_nvml_dev"
        "cuda_cccl"
        "libcublas"
        "1password"
        "steam"
        "steam-original"
        "steam-run"
        "modrinth-app"
        "modrinth-app-unwrapped"
        "vscode"
        "blender"
        "vcv-rack"
        "bitwig-studio"
        "roomeqwizard"
        "obsidian"
        "discord"
        "spotify"
        ];
  };
}