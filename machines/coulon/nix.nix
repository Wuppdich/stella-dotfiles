{
  config,
  pkgs,
  lib,
  values,
  ...
}:
{
  nix = {
    settings = {
      # additional binary caches to use
      substituters = [
        "https://cache.nixos-cuda.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        values.coulon.binary-cache.public
      ];
      # this option is not in search, but documented here:
      # https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-secret-key-files
      secret-key-files = [ config.sops.secrets."coulon/binary-cache/private".path ];
    };
  };

  nixpkgs.config = {

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
        "bitwig-studio6"
        "roomeqwizard"
        "obsidian"
        "discord"
        "spotify"
        "bitwig-studio-unwrapped"
        "davinci-resolve"
      ];
  };
}
