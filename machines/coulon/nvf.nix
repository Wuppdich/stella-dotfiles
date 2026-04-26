{
  pkgs,
  ...
}:
let
  # TODO: move this to flakes?
  nvf = import (builtins.fetchTarball {
    url = "https://github.com/notashelf/nvf/archive/cd1317aff7c9db7a8e1589c6119b7503f9036d24.tar.gz";
    # Optionally, you can add 'sha256' for verification and caching
    sha256 = "sha256:0043z1b0kyacwbc4f6apf5na2hvj6vvrppvij10k6xsmahw6l9f8";
  });
in {
  imports = [
    # Import the NixOS module from your fetched input
    nvf.nixosModules.nvf
  ];

  # Once the module is imported, you may use `programs.nvf` as exposed by the
  # NixOS module.
  programs = {
    nvf = {
      enable = true;
      settings.vim = {
        languages = {
          bash.enable = true;
          css.enable = true;
          haskell.enable = true;
          helm.enable = true;
          html.enable = true;
          lua.enable = true;
          markdown.enable = true;
          nix.enable = true;
          python.enable = true;
          rust.enable = true;
          sql.enable = true;
          yaml.enable = true;
        };
      };
    };
    neovim = {
      enable = true;
      # alias vim to nvim
      vimAlias = true;
      # set nvim as default
      defaultEditor = true;
    };
  };
  environment.systemPackages = with pkgs; [
    ripgrep
  ];
}
