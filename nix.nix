{
  config,
  pkgs,
  lib,
  ...
}:
{
  nix = {
    optimise = {
      automatic = true;
      dates = [ "daily" ];
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
        "https://cache.nixos-cuda.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
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
      unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
    };
    # permittedInsecurePackages = [
    #   "electron-33.4.11"
    # ];

    # join UnfreePredicate with pkgs._cuda.lib.allowUnfreeCudaPredicate somehow
    # https://nixos.org/manual/nixpkgs/unstable/#cuda-configuring-nixpkgs-for-cuda
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        # declare allowed unfree packages here
        "nvidia-x11"
        "nvidia-persistenced"
        "nvidia-settings"
        "cuda_cccl"
        "cuda_cudart"
        "cuda-merged"
        "cuda_cuobjdump"
        "cuda_cupti"
        "cuda_cuxxfilt"
        "cuda_gdb"
        "cuda_nvdisasm"
        "cuda_nvcc"
        "cuda_nvml_dev"
        "cuda_nvprune"
        "cuda_nvtx"
        "cuda_nvrtc"
        "cuda_profiler_api"
        "cuda_sanitizer_api"
        "cudnn"
        "libcublas"
        "libcufft"
        "libcusolver"
        "libcurand"
        "libcusparse"
        "libnvjitlink"
        "libnpp"
        "libcufile"
        "libcusparse_lt"
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
        "bitwig-studio-unwrapped"
        "davinci-resolve"
      ];
  };
}
