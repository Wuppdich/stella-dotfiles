{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../machine-base.nix
    ./fix.nix
    ./nix.nix
    ./locale.nix
    ./nvidia.nix
    ./alice.nix
    ./home-manager.nix
    ./gdm.nix
    ./nvf.nix
  ];

  # this will instantiate the secret in /run/secrets, making it available after evaluation
  sops.secrets."coulon/binary-cache/private" = {
    group = "wheel";
    mode = "444";
  };

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Setup keyfile (TODO: do this with sops?)
    initrd = {
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      # Enable swap on luks
      luks.devices."luks-9c5a0fd5-c5a3-4376-a9ca-abd0e7a6a9af" = {
        device = "/dev/disk/by-uuid/9c5a0fd5-c5a3-4376-a9ca-abd0e7a6a9af";
        keyFile = "/crypto_keyfile.bin";
      };
    };
    # nct6775 enables Motherboard Sensors (like Voltages)
    kernelModules = [ "nct6775" ];
  };

  networking = {
    hostName = "coulon"; # Define your hostname.

    # Enable networking
    networkmanager.enable = true;
  };

  # Configure console keymap
  console.keyMap = "de";

  hardware = {
    graphics.enable32Bit = true;
  };

  security.rtkit.enable = true;

  # Enable sound with pipewire.
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    pulseaudio.enable = false;
    openssh = {
      enable = false;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    usbmuxd.enable = true; # iPhone
  };

  musnix.enable = true;

  fonts.fontDir.enable = true;
  fonts.enableDefaultPackages = true;
  # install specific fonts
  fonts.packages = with pkgs; [
    (google-fonts.override {
      fonts = [
        "Pathway Gothic One"
        "Roboto"
      ];
    })
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.symbols-only
  ];

  users.defaultUserShell = pkgs.fish;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # libs/envs/daemons
    wineWowPackages.waylandFull
    libimobiledevice # iPhone
    ifuse # iPhone
    winetricks
    lm_sensors
    # tools
  ];

  programs = {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    fish.enable = true;
    starship.enable = true;
    # https://nix-community.github.io/home-manager/index.xhtml#_why_do_i_get_an_error_message_about_literal_ca_desrt_dconf_literal_or_literal_dconf_service_literal
    # dconf.enable = true;

    _1password-gui = {
      enable = true;
      # allow unlocking with user password
      polkitPolicyOwners = [ "alice" ];
    };
    firefox.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    git.package = pkgs.git;
    direnv.enable = true;
    wireshark.enable = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # nfs ohne kerberos ist nicht transparent. Alle Dateien werden aktuell auf dem Server
  # dem "admin"-Nutzer zugeschrieben.
  fileSystems =
    let
      makeNfsFilesystem = targetDevice: {
        device = "fragment-1:/volume1/" + targetDevice;
        fsType = "nfs";
        options = [
          "nfsvers=4.1"
          "nofail"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "comment=x-gvfs-hide"
        ];
      };
    in
    {
      "/home/alice/Bilder" = (makeNfsFilesystem "Personal Files/Pictures");
      "/home/alice/Dokumente" = (makeNfsFilesystem "Personal Files/Documents");
      "/home/alice/Musik" = (makeNfsFilesystem "Music");
      "/home/alice/Videos" = (makeNfsFilesystem "Personal Files/Videos");
      "/home/alice/Downloads" = (makeNfsFilesystem "Personal Files/Downloads");
    };

  system = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "23.05"; # Did you read the comment?
  };
}
