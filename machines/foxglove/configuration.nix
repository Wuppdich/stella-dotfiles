# a VPS (4 Cores, 8GB Ram) hosted by contabo
{
  lib,
  pkgs,
  config,
  values,
  ...
}@args:
{
  sops.secrets.password-server-foxglove.neededForUsers = true;

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "foxglove";
    contabo = {
      enable = true;
      mac = values.foxglove.mac;
      addresses = values.foxglove.ipAdresses;
    };
  };
  time.timeZone = "Europe/Berlin";
  # console.keyMap = "de";

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
        hashedPasswordFile = config.sops.secrets.password-server-foxglove.path;
      };

      root = {
      };
    };
  };

  nix = {
    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };
    # The nix-daemon's scheduling priority is set lowest to lessen the impact on system performance
    # during auto-Upgrades
    daemonIOSchedPriority = 7; # 0 is highest, 7 is lowest
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # we need to read this from a file in the repo, because there is no way to set a key file directly.
        values.coulon.binary-cache.public
      ];
    };
  };

  system = {
    # FIXME: add channels
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      rebootWindow = {
        lower = "01:00";
        upper = "05:00";
      };
      flags = [ "--max-jobs 1" ];
      runGarbageCollection = true;
    };
    stateVersion = "25.11";
  };
}
