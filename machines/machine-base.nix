# definitions, that apply to all machines
{
  inputs,
  pkgs,
  config,
  ...
}:
{
  sops = {
    # required key file
    age.keyFile = "/home/alice/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets.yaml;
  };

  # attributes, that can be input into other nix modules (just like inputs, pkgs, config etc.)
  _module.args = {
    values = import ../values.nix;
    pkgsUnstable = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };
  };

  imports = [
    ../modules/lix.nix
  ];

  environment.systemPackages = with pkgs; [
    curl
    btop
    hyfetch
  ];

  programs = {
    git = {
      enable = true;
      package = pkgs.gitMinimal;
    };
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };
}
