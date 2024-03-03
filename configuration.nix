# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

# https://nixos.wiki/wiki/FAQ#How_can_I_install_a_package_from_unstable_while_remaining_on_the_stable_channel.3F
# https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
# good luck future-girl
let
  unstable = import (builtins.fetchGit {
    name = "nixos-unstable-2024-02-07";
    url = "https://github.com/nixos/nixpkgs/";
    # > git ls-remote https://github.com/nixos/nixpkgs nixos-unstable
    ref = "refs/heads/nixos-unstable";
    rev = "faf912b086576fd1a15fca610166c98d47bc667e";
  })
  { config = config.nixpkgs.config; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # optimize store by hardlinking files
  nix.optimise = {
    automatic = true;
    dates = ["daily"];
  };

  # summon the dump-truck
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-9c5a0fd5-c5a3-4376-a9ca-abd0e7a6a9af" = {
    device = "/dev/disk/by-uuid/9c5a0fd5-c5a3-4376-a9ca-abd0e7a6a9af";
    keyFile = "/crypto_keyfile.bin";
  };

  # nct6775 enables Motherboard Sensors (like Voltages)
  boot.kernelModules = ["nct6775" ];

  networking.hostName = "coulon"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable OpenGL
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = false;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # ensures all GPUs stay away during headless mode
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  fonts.packages = with pkgs; [
    (google-fonts.override { fonts = [ "Pathway Gothic One" ]; })
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alice = {
    isNormalUser = true;
    description = "alice";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [
      firefox
      thunderbird
      kitty
      steam
      prusa-slicer
      openscad
      vscode
      unstable.arduino-ide
      (pkgs.makeDesktopItem {
        name = "arduino-ide";
        desktopName = "Arduino IDE";
        exec = "arduino-ide";
      })
      thonny
      blender
      gimp
      vlc
      geeqie
      libreoffice
      tor-browser
      obsidian
      heroic
      itch
      prismlauncher
      discord
      spotify
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
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
    cudaSupport = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python3
    neovim
    git
    btop
    wineWowPackages.waylandFull
    winetricks
    lm_sensors
  ];

  # fix crackling noises
  environment.etc = {
    "wireplumber/main.lua.d/51-disable-suspension.lua" = {
      text = ''
        table.insert (alsa_monitor.rules, {
          matches = {
            {
              -- Matches all sources.
              { "node.name", "matches", "alsa_input.*" },
            },
            {
              -- Matches all sinks.
              { "node.name", "matches", "alsa_output.*" },
            },
          },
          apply_properties = {
            ["session.suspend-timeout-seconds"] = 300,  -- 0 disables suspend
          },
        })
      '';
      mode = "0554";
    };
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.neovim = {
    # alias vim to nvim
    vimAlias = true;
    # set vim as default
    defaultEditor = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "alice" ];
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;  
  fileSystems = 
    let makeNfsFilesystem = targetDevice: {
      device = "192.168.1.5:/volume1/" + targetDevice;
      fsType = "nfs";
      options = ["nfsvers=4.1" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "comment=x-gvfs-hide"];
    };
    in {
      "/home/alice/Bilder" = (makeNfsFilesystem "Personal Files/Pictures");
      "/home/alice/Dokumente" = (makeNfsFilesystem "Personal Files/Documents");
      "/home/alice/Musik" = (makeNfsFilesystem "Music");
      "/home/alice/Videos" = (makeNfsFilesystem "Personal Files/Videos");
      "/home/alice/Downloads" = (makeNfsFilesystem "Personal Files/Downloads");
    };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
