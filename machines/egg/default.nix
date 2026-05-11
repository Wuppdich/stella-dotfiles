# transition system from any *nix-system to NixOS via nixos-anywhere
{
  modulesPath,
  ...
}:
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../machine-base.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "egg";
    contabo = {
      enable = true;
      # set mac, IPv4 and IPv6 addresses
      mac = "00:00";
      addresses = [ "123.123.123.123"  "01::1" ];
    };
  };

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "# CHANGE"
  ];

  system = {
    autoUpgrade.enable = false;
    stateVersion = "24.05";
  };
}
