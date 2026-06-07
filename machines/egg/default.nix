# transition system from any *nix-system to NixOS via nixos-anywhere
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
        coulon.ssh-public.root
        coulon.ssh-public.alice
        pyrit.ssh-public.alice
        pyrit.ssh-public.root
      ];
      hashedPassword = values.egg.root.hashedPassword;
    };
  };

  system = {
    autoUpgrade.enable = false;
    stateVersion = "24.05";
  };
}
