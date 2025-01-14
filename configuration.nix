# run "sudo nix-channel --add https://github.com/XYZ nixos" to add a new channel as the default.
# home-manager https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz
# nixos https://channels.nixos.org/nixos-24.05
# nixos-unstable https://nixos.org/channels/nixos-unstable
# nix-channel --update

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    # ./allowedUnfree.nix
    ./musnix
    ./fix.nix
    ./home-manager.nix
  ];

  nix = {
    optimise = {
      automatic = true;
      dates = ["daily"];
    };
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

  hardware = {
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = true;
      # ensures all GPUs stay awake during headless mode
      nvidiaPersistenced = true;
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = true;
      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      # Load nvidia driver for Xorg and Wayland
      videoDrivers = ["nvidia"];
      # Configure keymap in X11
      xkb = {
        layout = "de";
        variant = "";
      };
    };
    # Enable CUPS to print documents.
    printing.enable = true;
  };

  # Configure console keymap
  console.keyMap = "de";

  hardware = {
    pulseaudio.enable = false;
    graphics.enable32Bit = true;
  };
  security.rtkit.enable = true;
  # Enable sound with pipewire.
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
    extraGroups = [ "networkmanager" "wheel" "dialout" "audio" "wireshark" ];
    packages = with pkgs; [
      # internet
      firefox
      wireshark
      # desktop entries to launch firefox with custom profiles
      (pkgs.makeDesktopItem {
        name = "youtube";
        desktopName = "YouTube";
        exec = "firefox -P youtube-machine";
      })
      (pkgs.makeDesktopItem {
        name = "twitch";
        desktopName = "Twitch";
        exec = "firefox -P twitch-machine";
      })
      thunderbird
      tor-browser
      discord
      # programmierung
      kitty
      vscode
      arduino-ide
      thonny
      # gaming
      steam
      lutris
      ludusavi
      heroic
      unstable.itch
      prismlauncher
      # CGI/CAD
      unstable.prusa-slicer
      openscad-unstable
      blender
      unstable.freecad
      gimp
      vlc
      geeqie
      # audio
      spotify
      rhythmbox
      vcv-rack
      ardour
      bitwig-studio
      audacity
      plugdata
      roomeqwizard
      # office
      libreoffice
      (texliveMedium.withPackages (ps: with ps; [ blindtext multirow roboto makecell fontaxes]))
      obsidian
      calibre
    ];
  };

  users.defaultUserShell = pkgs.fish;

  nixpkgs.config = {
    # alias for the unstable channel
    # (channel needs to be added via nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable)
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {config = config.nixpkgs.config; };
    };
    cudaSupport = true;
    allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
        # declare allowed unfree packages here
        "nvidia-x11"
        "nvidia-persistenced"
        "nvidia-settings"
        "cuda_cudart"
        "cuda_nvcc"
        "cuda_nvml_dev"
        "cuda_cccl"
        "libcublas"
        "libcurand"
        "libcusparse"
        "libnvjitlink"
        "libcufft"
        "cudnn"
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
    # libs/envs/daemons
    wineWowPackages.waylandFull
    winetricks
    lm_sensors
    # tools
    neovim
    git
    btop
    # settings
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
    wireshark.enable = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # nfs ohne kerberos ist nicht transparent. Alle Dateien werden aktuell auf dem Server
  # dem "admin"-Nutzer zugeschrieben. 
  fileSystems = 
    let makeNfsFilesystem = targetDevice: {
      device = "fragment-1:/volume1/" + targetDevice;
      fsType = "nfs";
      options = ["nfsvers=4.1" "nofail" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=600" "comment=x-gvfs-hide"];
    };
    in {
      "/home/alice/Bilder" = (makeNfsFilesystem "Personal Files/Pictures");
      "/home/alice/Dokumente" = (makeNfsFilesystem "Personal Files/Documents");
      "/home/alice/Musik" = (makeNfsFilesystem "Music");
      "/home/alice/Videos" = (makeNfsFilesystem "Personal Files/Videos");
      "/home/alice/Downloads" = (makeNfsFilesystem "Personal Files/Downloads");
    };

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
