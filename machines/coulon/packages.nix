{ pkgs, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # libs/envs/daemons
    egl-wayland # for hyprland
    wineWow64Packages.waylandFull
    libimobiledevice # iPhone
    ifuse # iPhone
    winetricks
    lm_sensors
    # tools
  ];
}
