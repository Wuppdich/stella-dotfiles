# a VPS (4 Cores, 8GB Ram) hosted by contabo
{
  modulesPath,
  config,
  values,
  ...
}:
{
  imports = [
    ../machine-base.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  sops.secrets.rabe.passwords.server.neededForUsers = true;

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
      mac = values.rabe.mac;
      addresses = values.rabe.ipAdresses;
    };
  };

  time.timeZone = "Europe/Berlin";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  virtualisation.docker.enable = true;

  users = {
    # required so nix can update passwords
    mutableUsers = false;
    users = {
      server = {
        isNormalUser = true;
        description = "server";
        extraGroups = [
          "wheel"
          "docker"
        ];
        openssh.authorizedKeys.keys = with values; [
          coulon.ssh.root.ed25519.public
          coulon.ssh.alice.ed25519.public
        ];
        hashedPasswordFile = config.sops.secrets.rabe.passwords.server.path;
      };

      root = {
        password = null;
      };
    };
  };

  system = {
    autoUpgrade.allowReboot = true;
    stateVersion = "25.11";
  };
}
