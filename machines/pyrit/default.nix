{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    inputs.musnix.nixosModules.musnix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./fix.nix
    ../machine-base.nix
    ./alice-user.nix
    ./boot.nix
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./home
  ];

  garden.gnome.enable = true;

  networking = {
    hostName = "pyrit";
    networkmanager.enable = true;
  };

  # Configure console keymap
  console.keyMap = "de";

  hardware = {
    graphics = {
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
      ];
    };
  };

  security.rtkit.enable = true;
  # Enable sound with pipewire.

  musnix.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # install specific fonts
  fonts.packages = with pkgs; [
    (google-fonts.override {
      fonts = [
        "Pathway Gothic One"
        "Roboto"
      ];
    })
  ];

  users.defaultUserShell = pkgs.fish;

  system = {
    autoUpgrade.operation = "boot";
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "23.05"; # Did you read the comment?
  };
}
