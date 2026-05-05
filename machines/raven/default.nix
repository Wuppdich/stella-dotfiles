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
    ../../modules/contabo-networking.nix
    ./disk-config.nix
  ];
  sops.secrets.password-server-raven.neededForUsers = true;

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "raven";
    contabo = {
      enable = true;
      mac = values.raven.mac;
      addresses = values.raven.ipAdresses;
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
        hashedPasswordFile = config.sops.secrets.password-server-raven.path;
      };

      root = {
        password = null;
      };
    };
  };

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      values.coulon.binary-cache.public
    ];
  };

  system = {
    autoUpgrade.allowReboot = true;
    stateVersion = "25.11";
  };
}
