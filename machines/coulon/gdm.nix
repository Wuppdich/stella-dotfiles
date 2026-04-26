{
  ...
}:
{
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Load nvidia driver for Xorg and Wayland
      videoDrivers = [ "nvidia" ];
    };
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
}
