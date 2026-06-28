# a VPS (4 Cores, 8GB Ram) hosted by contabo
{
  modulesPath,
  values,
  inputs,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    inputs.disko.nixosModules.disko
    inputs.quadlet-nix.nixosModules.quadlet
    ../machine-base.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ./disk-config.nix
    ./server-user.nix
    ./services.nix
    ./containers.nix
  ];

  sops.secrets."rabe/passwords/server".neededForUsers = true;

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "rabe";
    contabo = {
      enable = true;
      inherit (values.rabe.network-interface) mac addrIPv4 addrIPv6;
    };
    nftables.enable = true;
  };

  time.timeZone = "Europe/Berlin";
  
  virtualisation.docker.enable = true;
  # bunch of terminfos so fancy terminal stuff won't break
  environment.enableAllTerminfo = true;

  users = {
    # required so nix can update passwords
    mutableUsers = false;
    users.root = {
      password = null;
    };
  };

  system = {
    autoUpgrade.allowReboot = true;
    stateVersion = "25.11";
  };
}
