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
        "cuda_cccl"
        "libcublas"
        "1password"
        "steam"
        "steam-original"
        "steam-run"
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