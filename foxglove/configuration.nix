{
  modulesPath,
  lib,
  pkgs,
  config,
  ...
}@args:
{
  sops = {
    # required key file
    age.keyFile = "/home/alice/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets.yaml;
    secrets.password-server-foxglove.neededForUsers = true;
  };

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./contabo-networking.nix
    ../lix.nix
  ];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostName = "foxglove";
  time.timeZone = "Europe/Berlin";
  # console.keyMap = "de";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.systemPackages =
    with pkgs;
    map lib.lowPrio [
      curl
      btop
      hyfetch
    ];

  programs = {
    git = {
      enable = true;
      package = pkgs.gitMinimal;
    };
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
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
        openssh.authorizedKeys.keys = [
          "123"
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
        (builtins.readFile ../coulon_nix_key.pub)
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
