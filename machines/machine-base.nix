# definitions, that apply to all machines
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  sops = {
    defaultSopsFile = "${builtins.toString inputs.secrets}/secrets.yaml";
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  # attributes, that can be input into other nix modules (just like inputs, pkgs, config etc.)
  _module.args = {
    values = import "${builtins.toString inputs.secrets}/values.nix";
    pkgsUnstable = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };
  };

  imports = [
    ../modules/lix.nix
    ../modules/contabo-networking.nix
  ];

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
    settings.experimental-features = "nix-command flakes lix-custom-sub-commands";
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
