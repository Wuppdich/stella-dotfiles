# transition system from any *nix-system to NixOS via nixos-anywhere
{
  modulesPath,
  values,
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

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  users = {
    mutableUsers = false;
    users.root = {
      openssh.authorizedKeys.keys = with values; [
        coulon.ssh.root.ed25519.public
        coulon.ssh.alice.ed25519.public
        pyrit.ssh.alice.ed25519.public
        pyrit.ssh.root.ed25519.public
      ];
      hashedPassword = values.egg.root.hashedPassword;
    };
  };

  system = {
    autoUpgrade.enable = false;
    stateVersion = "24.05";
  };
}
