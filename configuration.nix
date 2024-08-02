# run "sudo nix-channel --add https://github.com/XYZ nixos" to add a new channel as the default.

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports = [ 
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    <home-manager/nixos>
    ./allowedUnfree.nix
    ./musnix
    ./nagfix.nix
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

  nix.settings = {
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

  hardware.nvidia = {
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

  services.xserver = {
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

  # deactivated due to gnome-power-governor
  # services.auto-cpufreq.enable = true;
  # services.auto-cpufreq.settings = {
  #   charger = {
  #     turbo = "auto";
  #   };
  # };

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
      prusa-slicer
      openscad
      vscode
      arduino-ide
      thonny
      blender
      gimp
      vlc
      vcv-rack
      ardour
      bitwig-studio
      audacity
      plugdata
      geeqie
      roomeqwizard
      libreoffice
      tor-browser
      obsidian
      heroic
      unstable.itch
      prismlauncher
      modrinth-app
      discord
      rhythmbox
      spotify
      calibre
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
      bisq-desktop
      gpu-screen-recorder
      vulnix
      lynis
    ];
  };

  environment.sessionVariables = rec{
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
  };

  musnix.enable = true;

  nixpkgs.config = {
    # alias for the unstable channel
    # (channel needs to be added via nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable)
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {config = config.nixpkgs.config; };
    };
    cudaSupport = true;
    # required for some package i forgor
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python3Full
    neovim
    git
    btop
    wineWowPackages.waylandFull
    winetricks
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

  programs = {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
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
    gamemode.enable = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
