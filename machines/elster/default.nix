{ config, pkgs, ... }:

{
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../machine-base.nix
    ./server-user.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  sops.secrets."elster/passwords/server".neededForUsers = true;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "elster";
    nftables.enable = true;
  };

  # Configure console keymap
  console.keyMap = "de";

  # bunch of terminfos so fancy terminal stuff won't break
  environment.enableAllTerminfo = true;

  environment.systemPackages = with pkgs; [
  ];

  users = {
    # required so nix can update passwords
    mutableUsers = false;
    users.root = {
      password = null;
    };
  };

  services.openssh.enable = true;

  system.stateVersion = "26.05";

}
