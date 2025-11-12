{ config, pkgs, lib, ... }:
let
  nvf = import (builtins.fetchTarball {
    url = "https://github.com/notashelf/nvf/archive/da5c91424e6d5028c7cfd171833ac7a71f98cbfc.tar.gz";
    # Optionally, you can add 'sha256' for verification and caching
    sha256 = "sha256:0p2qywnv4x89j5qayb132wapapzz846f7lgng9pkj33lgk27x3pl";
  });
in {
  imports = [
    # Import the NixOS module from your fetched input
    nvf.nixosModules.nvf
  ];

  # Once the module is imported, you may use `programs.nvf` as exposed by the
  # NixOS module.
  programs = {
    nvf.enable = true;
    neovim = {
        enable = true;
        # alias vim to nvim
        vimAlias = true;
        # set nvim as default
        defaultEditor = true;
        };
  };
}