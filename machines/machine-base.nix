# definitions, that apply to all machines
{
  inputs,
  pkgs,
  config,
  lib,
  values,
  ...
}:
{
  sops = {
    defaultSopsFile = "${builtins.toString inputs.secrets}/secrets.yaml";
    age = {
      # we want no generated keys
      sshKeyPaths = [ ];
      generateKey = false;
      keyFile = "/var/lib/sops-nix/key.txt";
    };
  };

  # attributes, that can be input into other nix modules (just like inputs, pkgs, config etc.)
  _module.args = {
    values = import "${builtins.toString inputs.secrets}/private.nix";
    pkgsUnstable = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };
  };

  time.timeZone = lib.mkDefault "Europe/Berlin";

  imports = [
    ../modules
  ];
  
  garden.lix.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    btop
    hyfetch
  ];

  programs = {
    git = {
      enable = true;
      package = lib.mkDefault pkgs.gitMinimal;
    };
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };

  nix = {
    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      options = "--delete-older-than 7d";
    };
    # The nix-daemon's scheduling priority is set lowest to lessen the impact on system performance
    # during auto-Upgrades
    daemonIOSchedPriority = 7; # 0 is highest, 7 is lowest
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
        values.pyrit.binary-cache.public
      ];
      experimental-features = "nix-command flakes lix-custom-sub-commands";
    };
  };

  system = {
    autoUpgrade = {
      enable = lib.mkDefault true;
      dates = "01:00";
      fixedRandomDelay = true;
      randomizedDelaySec = "3h";
      upgrade = false;
      flake = "github:Wuppdich/stella-dotfiles";
      operation = lib.mkDefault "boot";
      allowReboot = lib.mkDefault false;
      rebootWindow = {
        lower = "01:00";
        upper = "05:00";
      };
      # FIXME: prevents OOM's. leave this at 1 until we have a way to monitor rebuild's RAM-usage
      flags = [ "--max-jobs 1" ];
      runGarbageCollection = true;
    };
  };
}
