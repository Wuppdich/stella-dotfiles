{ config, pkgs, lib, ... }:
{
  nix = {
    optimise = {
      automatic = true;
      dates = ["daily"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      options = "--delete-older-than 30d";
    };
    settings = {
      # additional binary caches to use
      substituters = [
        "https://cuda-maintainers.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = "nix-command flakes";
    };
    # The nix-daemon's scheduling priority is set lowest to lessen the impact on system performance
    # during auto-Upgrades
    daemonIOSchedPriority = 7; # 0 is highest, 7 is lowest
  };

  nixpkgs.config = {
    # alias for the unstable channel
    # (channel needs to be added via nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable)
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {config = config.nixpkgs.config; };
    };
    # permittedInsecurePackages = [
    #   "electron-33.4.11"
    # ];
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
        "libcurand"
        "libcusparse"
        "libnvjitlink"
        "libcufft"
        "cudnn"
        "1password"
        "steam"
        "steam-original"
        "steam-unwrapped"
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
        "libnpp"
        "bitwig-studio-unwrapped"
        "cuda_nvrtc"
        ];
  };
}