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
    ./nix.nix
    ./locale.nix
    ./nvidia.nix
    ./gdm.nix
  ];

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

    # Enable networking
    networkmanager.enable = true;
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
    extraGroups = [ "networkmanager" "wheel" "dialout" "audio" "wireshark" "docker" ];
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
      obsidian
      calibre
    ];
  };

  users.defaultUserShell = pkgs.fish;

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

  virtualisation.docker.enable = true;

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
