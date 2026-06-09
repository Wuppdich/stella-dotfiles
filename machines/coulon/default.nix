{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [
    inputs.musnix.nixosModules.musnix
    ./hardware-configuration.nix
    ../machine-base.nix
    ./fix.nix
    ./nix.nix
    ./locale.nix
    ./nvidia.nix
    ./alice-user.nix
    ./nvf.nix
    ./boot.nix
    ./fonts.nix
    ./filesystems.nix
    ./services.nix
    ./programs.nix
    ./packages.nix
    ./home
  ];

  garden.hyprland.enable = true;

  # this will instantiate the secret in /run/secrets, making it available after evaluation
  sops.secrets."coulon/binary-cache/private" = {
    group = "wheel";
    mode = "444";
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

  # realtime management
  security.rtkit.enable = true;
  musnix.enable = true;

  qt.enable = true;

  users.defaultUserShell = pkgs.fish;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

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
