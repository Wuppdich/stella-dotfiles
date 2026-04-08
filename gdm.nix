{
  config,
  pkgs,
  lib,
  ...
}:
{
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Load nvidia driver for Xorg and Wayland
      videoDrivers = [ "nvidia" ];
      # Configure keymap in X11
      xkb = {
        layout = "de";
        variant = "";
      };
    };
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
}
