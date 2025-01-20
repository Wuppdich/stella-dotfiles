# run "sudo nix-channel --add https://github.com/XYZ nixos" to add a new channel as the default.

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:{
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    ./musnix
    ./fix.nix
    ./home-manager.nix
  ];

  nix = {
    optimise = {
      automatic = true;
      dates = ["daily"];
    };
    # summon the dump-truck
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      options = "--delete-older-than 30d";
    };
    settings = {
      # additional binary caches to use
      substituters = [
        "https://cuda-maintainers.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = "nix-command flakes";
    };
  };

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Setup keyfile
    initrd = {
      secrets = { "/crypto_keyfile.bin" = null; };
      # Enable swap on luks
      luks.devices."luks-75097e1b-c10e-45f7-85bd-294e80ea40d0" = {
        device = "/dev/disk/by-uuid/75097e1b-c10e-45f7-85bd-294e80ea40d0";
        keyFile = "/crypto_keyfile.bin";
      };
    };
  };

  networking = {
    hostName = "lambda03"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Enable networking
    networkmanager.enable = true;
  };


  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "de_DE.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
    ];
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    # Configure keymap in X11
    xkb = {
      layout = "de";
      variant = "";
    };
  };

  # managed by gnome power daemon :TODO fix this
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
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

  musnix.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # install specific fonts
  fonts.packages = with pkgs; [
    (google-fonts.override { fonts = [ "Pathway Gothic One" "Roboto" ]; })
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alice = {
    isNormalUser = true;
    description = "alice";
    # "wheel" for sudo
    # "dialout" for parallel protocols (moisture sensor)
    # "audio" for realtime audio
    extraGroups = [ "networkmanager" "wheel" "dialout" "audio" ];
    packages = with pkgs; [
      firefox
      thunderbird
      kitty
      steam
      unstable.prusa-slicer
      openscad-unstable
      vscode
      blender
      gimp
      libreoffice
      obsidian
      heroic
      vcv-rack
      unstable.itch
      unstable.freecad
      prismlauncher
      discord
      vulnix
      lynis
    ];
  };

  users.defaultUserShell = pkgs.fish;

  nixpkgs.config = {
    # alias for the unstable channel
    # (channel needs to be added via nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable)
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {config = config.nixpkgs.config; };
    };
    # required for some package i forgor
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
    allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          # declare allowed unfree packages here
          "1password"
          "steam"
          "steam-original"
          "steam-unwrapped"
          "steam-run"
          "modrinth-app"
          "modrinth-app-unwrapped"
          "vscode"
          "blender"
          "vcv-rack"
          "bitwig-studio"
          "roomeqwizard"
          "obsidian"
          "discord"
          "spotify"
        ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    lm_sensors
    # blend file thumbnailer
    (pkgs.writeTextFile {
      name = "blender thumbnails";
      text = ''
        [Thumbnailer Entry]
        TryExec=blender-thumbnailer
        Exec=blender-thumbnailer %i %o
        MimeType=application/x-blender;
      '';
      destination = "/share/thumbnailers/blender.thumbnailer";
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    xwayland.enable = true;
    fish.enable = true;
    starship.enable = true;
    # https://nix-community.github.io/home-manager/index.xhtml#_why_do_i_get_an_error_message_about_literal_ca_desrt_dconf_literal_or_literal_dconf_service_literal
    # dconf.enable = true;
    neovim = {
      enable = true;
      # alias vim to nvim
      vimAlias = true;
      # set nvim as default
      defaultEditor = true;
    };
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
    git.enable = true;
    direnv.enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # fileSystems."/home/alice/disk" = {
  #   device = "192.168.1.5:/volume1/Personal Files/";
  #   fsType = "nfs";
  #   options = ["_netdev" "bg" "nfsvers=4.1" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
  # };

  # The nix-daemon's scheduling priority is set lowest to lessen the impact on system performance
  # during auto-Upgrades
  nix.daemonIOSchedPriority = 7; # 0 is highest, 7 is lowest

  system = {
    autoUpgrade = {
      enable = true;
      operation = "boot";
    };
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "23.05"; # Did you read the comment?
  };
}
